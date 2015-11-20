package kz.aphion.brainfights.services;

import kz.aphion.brainfights.persistents.user.Department;
import kz.aphion.brainfights.persistents.user.User;
import play.db.jpa.JPA;

import javax.jws.soap.SOAPBinding;
import javax.naming.Context;
import javax.naming.InvalidNameException;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.*;
import javax.naming.ldap.LdapName;
import javax.naming.ldap.Rdn;
import javax.persistence.EntityTransaction;
import javax.swing.text.html.parser.Entity;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Hashtable;
import java.util.List;

/**
 * Created by alimjan on 18.11.2015.
 */
public class ADService {
    public static final String CONTEXT_FACTORY="com.sun.jndi.ldap.LdapCtxFactory";
//    public static final String LDAP_URL = "ldap://169.254.148.46:389";
    public static final String LDAP_URL = "ldap://alimjanns.ddns.net:390";
    public static final String LDAP_AUTH_TYPE = "simple";
    public static final String LDAP_DOMAIN = "transtelecom.kz";
    public static final String LDAP_SECURITY_PRINCIPAL = "cn=Alimjan Nurpeissov,cn=users,dc=transtelecom,dc=kz";
    public static final String LDAP_SECURITY_CREDENTIALS = "Monte6deo";
    public static final String ROOT_DEPARTMENT = "TRANSTELECOM";
    public static final String ATTRIBUTE_DN = "distinguishedname";


    private static DirContext ldapContext=null;

    public static DirContext getLDAPContext() throws NamingException {
//        if(ldapContext==null){            //TODO: Проверка состояния соединения
            ldapContext = initLDAPContext();
//        }
        return ldapContext;
    }

    public static void updateAllFromLdap() throws NamingException {
        List<Department> departments = getLdapDepartments();   //Вся структура
//        List<Department> departments = new ArrayList<Department>();  //Только там где пользователи
        List<User> users = getUsers();
        for (User user:users){
            NamingEnumeration<SearchResult> response = findUserInLDAP(user.getLogin());
            if(response!=null&&response.hasMoreElements()){
                SearchResult result = response.next();
                user = setUserDataFromResult(user,result.getAttributes());
                String dn = getLdapAttrValue(ATTRIBUTE_DN,result.getAttributes());
                List<String> path = parseDistinguishedName(dn);
//                List<Department> deps = new ArrayList<Department>();//TODO: DELETE THIS
                Department department = getDepartamentByPath(departments,path,null);
                user.setDepartment(department);
            }else{
                user.setDeleted(true);
            }
        }
        JPA.em().createNativeQuery("UPDATE users set department_id=null").executeUpdate();
        JPA.em().flush();
        JPA.em().createNativeQuery("DELETE FROM department").executeUpdate();
        saveDepartments(departments);
        saveUsers(users);
    }

    public static User authenticate(String login, String password){
        User user = User.find("from User where login=?", login).first();
        try {
            DirContext context = initLDAPContext(login,password);
            if(user!=null){
                NamingEnumeration<SearchResult> response = findUserInLDAP(login);
                if(response!=null&&response.hasMoreElements()){
                    SearchResult result = response.next();
                    user = setUserDataFromResult(user,result.getAttributes());
                    user.setLastActivityTime(Calendar.getInstance());
                    String dn = getLdapAttrValue(ATTRIBUTE_DN,result.getAttributes());
                    List<String> path = parseDistinguishedName(dn);
                    List<Department> departments = Department.find("from Department where parent=null").fetch();
                    Department department = getDepartamentByPath(departments,path,null);
                    user.setDepartment(department);
                    saveDepartments(departments);
                    user.save();
                    return user;
                }else{
                    return null;
                }
            }else{
                NamingEnumeration<SearchResult> response = findUserInLDAP(login);
                if(response!=null&&response.hasMoreElements()){
                    SearchResult result = response.next();
                    user = new User();
                    user.setLogin(login);
                    user.setPassword(password);//TODO: Надо удалить сохранение пароля
                    user = setUserDataFromResult(user,result.getAttributes());
                    user.setScore(0);
                    user.setLastActivityTime(Calendar.getInstance());
                    String dn = getLdapAttrValue(ATTRIBUTE_DN,result.getAttributes());
                    List<String> path = parseDistinguishedName(dn);
                    List<Department> departments = Department.find("from Department where parent=null").fetch();
                    Department department = getDepartamentByPath(departments,path,null);
                    user.setDepartment(department);
                    saveDepartments(departments);
                    user.save();
                    return user;
                }else{
                    return null;
                }
            }
        } catch (NamingException e) {
            e.printStackTrace();
            return null;
        }
    }
    private static User setUserDataFromResult(User user, Attributes attributes) throws NamingException {
        user.setPosition(getLdapAttrValue("description", attributes));
        user.setName(getLdapAttrValue("name", attributes));
        user.setEmail(getLdapAttrValue("mail", attributes));
        return user;
    }
    private static List<User> getUsers(){
        return User.all().fetch();
    }

    private static void saveUsers(List<User> users){
        for (User user:users){
            user.save();
        }
    }
    private static String getLdapAttrValue(String attrName, Attributes attributes) throws NamingException {
        Attribute attribute = attributes.get(attrName);
        if(attribute!=null){
            return (String) attribute.get();
        }
        return null;
    }
    private static NamingEnumeration<SearchResult> findUserInLDAP(String login) throws NamingException {
        SearchControls searchCtls = new SearchControls();
        String returnedAtts[] = {"*"};
        searchCtls.setReturningAttributes(returnedAtts);
        searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
        String searchFilter = "(&(objectClass=user)(sAMAccountName="+login+"))";
        String searchBase = "ou=TRANSTELECOM,dc=transtelecom,dc=kz";
        NamingEnumeration<SearchResult> answer = getLDAPContext().search(searchBase, searchFilter, searchCtls);
        return answer;
    }
    private static DirContext initLDAPContext() throws NamingException {
        Hashtable<String, String> ldapEnv = new Hashtable<String, String>(11);
        ldapEnv.put(Context.INITIAL_CONTEXT_FACTORY, CONTEXT_FACTORY);
        ldapEnv.put(Context.PROVIDER_URL,  LDAP_URL);
        ldapEnv.put(Context.SECURITY_AUTHENTICATION, LDAP_AUTH_TYPE);
        ldapEnv.put(Context.SECURITY_PRINCIPAL, LDAP_SECURITY_PRINCIPAL);
        ldapEnv.put(Context.SECURITY_CREDENTIALS, LDAP_SECURITY_CREDENTIALS);
        System.out.println(LDAP_SECURITY_PRINCIPAL);
        return new InitialDirContext(ldapEnv);

    }
    private static DirContext initLDAPContext(String login, String password) throws NamingException {
        Hashtable<String, String> ldapEnv = new Hashtable<String, String>(11);
        ldapEnv.put(Context.INITIAL_CONTEXT_FACTORY, CONTEXT_FACTORY);
        ldapEnv.put(Context.PROVIDER_URL,  LDAP_URL);
        ldapEnv.put(Context.SECURITY_AUTHENTICATION, LDAP_AUTH_TYPE);
        ldapEnv.put(Context.SECURITY_PRINCIPAL, login+"@"+ LDAP_DOMAIN);
        ldapEnv.put(Context.SECURITY_CREDENTIALS, password);
        System.out.println(LDAP_SECURITY_PRINCIPAL);
        return new InitialDirContext(ldapEnv);

    }

    private static List<Department> getLdapDepartments() throws NamingException {
        SearchControls searchCtls = new SearchControls();
        String returnedAtts[] = {"*"};
        searchCtls.setReturningAttributes(returnedAtts);
        searchCtls.setSearchScope(SearchControls.SUBTREE_SCOPE);
        String searchFilter = "(&(objectClass=organizationalUnit))";
        String searchBase = "ou=TRANSTELECOM,dc=transtelecom,dc=kz";
        NamingEnumeration<SearchResult> answer = getLDAPContext().search(searchBase, searchFilter, searchCtls);
        System.out.println(answer);
        List<Department> departments = new ArrayList<Department>();
        while (answer.hasMoreElements())
        {
            SearchResult sr = (SearchResult)answer.next();
//            System.out.println("Name ="+sr.getName());
            Attributes attrs = sr.getAttributes();
//            System.out.println("GUID ="+attrs.get(ATTRIBUTE_DN));
            List<String> path = parseDistinguishedName(String.valueOf(attrs.get(ATTRIBUTE_DN)));
            addDepartmentByPath(departments,path, null);
        }
        System.out.println();
//        Department d = Department.findById(Long.valueOf(2));
//        JPA.em().createQuery("user set de")
//        JPA.em().createNativeQuery("UPDATE users set ")
//        JPA.em().createNativeQuery("truncate table department").executeUpdate();
//        saveDepartments(departments);
        return departments;
    }
    private static void saveDepartments(List<Department> departments){
        for(Department department:departments){
            department.save();

            if(department.getChildren().size()>0){
                saveDepartments(department.getChildren());
            }
        }
    }
    private static void addDepartmentByPath(List<Department> departments, List<String> path, Department parent){
        if(path.size()>0){
            String departName = path.get(0);
            Department d = findDepartmentByName(departments, departName);
            if(d==null){
                d = new Department();
                d.setName(departName);
                d.setParent(parent);
                d.setChildren(new ArrayList<Department>());
                d.setScrore(0);
                d.setUserCount(0);
                departments.add(d);
            }
            path.remove(0);
            addDepartmentByPath(d.getChildren(),path, d);
        }
    }
    private static Department getDepartamentByPath(List<Department> departments, List<String> path, Department parent){
        if(path.size()>0){
            String departName = path.get(0);
            Department d = findDepartmentByName(departments, departName);
            if(d==null){
                d = new Department();
                d.setName(departName);
                d.setParent(parent);
                d.setChildren(new ArrayList<Department>());
                d.setScrore(0);
                d.setUserCount(0);
                departments.add(d);
            }
            path.remove(0);
            return getDepartamentByPath(d.getChildren(),path, d);
        }
        return parent;
    }
    private static Department findDepartmentByName(List<Department> departments, String name){
        for (Department department:departments){
            if(department.getName().equals(name)){
                 return department;
            }
        }
        return null;
    }
    private static List<String> parseDistinguishedName(String distinguishedName) throws InvalidNameException {
        String clearDistinguishedName =  null;
        if(distinguishedName.toLowerCase().contains(ATTRIBUTE_DN)){
            clearDistinguishedName = distinguishedName.split(":")[1];
        }else clearDistinguishedName = distinguishedName;
        LdapName dn = new LdapName(clearDistinguishedName);
        List<String> path = new ArrayList<String>();
        for(int i=0;i<dn.size();i++){
            Rdn a = dn.getRdn(i);
            if(a.getType().equals("DC"))continue;
            if(a.getType().equals("CN"))continue;
            if(a.getType().equals("OU")&&a.getValue().equals(ROOT_DEPARTMENT))continue;
            path.add(String.valueOf(a.getValue()));
        }
        return path;
    }
}
