package kz.aphion.groupbridge.brainfights;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.support.design.widget.NavigationView;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.support.v4.widget.DrawerLayout;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import java.text.ParseException;

import kz.aphion.groupbridge.brainfights.controllers.AboutFragment;
import kz.aphion.groupbridge.brainfights.controllers.GamesListsFragment;
import kz.aphion.groupbridge.brainfights.controllers.LoginActivity;
import kz.aphion.groupbridge.brainfights.controllers.SplashActivity;
import kz.aphion.groupbridge.brainfights.controllers.UserProfileFragment;
import kz.aphion.groupbridge.brainfights.controllers.UserProfileFragment2;
import kz.aphion.groupbridge.brainfights.controllers.rating.RatingParentFragment;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.push.RegistrationIntentService;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.stores.CurrentUserProfile;
import kz.aphion.groupbridge.brainfights.utils.Colors;
import kz.aphion.groupbridge.brainfights.utils.Const;
import kz.aphion.groupbridge.brainfights.utils.UserProfileUtil;

public class MainActivity extends AppCompatActivity
        /*implements NavigationDrawerFragment.NavigationDrawerCallbacks*/ {

    public static int MY_GAMES_FRAGMENT;
    public static int SPLASH_CHECK_AUTH_REQUEST;
    static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;

    //-------------------------------------------
    private DrawerLayout mDrawer;
    private Toolbar toolbar;
    private NavigationView nvDrawer;
    private DrawerLayout dlDrawer;
    private ActionBarDrawerToggle drawerToggle;
    //********************************************


    private CharSequence mTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
//        CurrentUser.init(this);
//        CurrentUser currentUser = CurrentUser.getInstance();
////        currentUser.removeAuthToken();
//        if(currentUser==null){
//            StartLoginActivity();
//        }else if(currentUser.getAuthToken()==null){
//            StartLoginActivity();
//        }
//        else{
//            StartSplashActivity();
//        }
        setContentView(R.layout.activity_main);
//        mNavigationDrawerFragment = (NavigationDrawerFragment)
//                getSupportFragmentManager().findFragmentById(R.id.navigation_drawer);
        //----------------------------------------------------------------------------------------
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        dlDrawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawerToggle = setupDrawerToggle();
        mDrawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        nvDrawer = (NavigationView) findViewById(R.id.nvView);
        setupDrawerContent(nvDrawer);
        View v = nvDrawer.getHeaderView(0);
        try {
            UserProfileUtil.setUserProfileUpData( CurrentUserProfile.getInstance(), v, getApplicationContext());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        //*****************************************************************************************


        mTitle = getTitle();
        Colors.initGameColors(getApplicationContext());
        // Set up the drawer.
//        mNavigationDrawerFragment.setUp(
//                R.id.navigation_drawer,
//                (DrawerLayout) findViewById(R.id.drawer_layout));
//        FragmentManager fragmentManager  = getSupportFragmentManager();
//        GamesListsFragment gamesListsFragment = new GamesListsFragment();
//        fragmentManager.beginTransaction().add(R.id.container, gamesListsFragment, "myFirstFragment").commit();
        if(checkPlayServices()) {
            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        }
        registerBroadcastReceivers();
        nvDrawer.getMenu().getItem(0).setChecked(true);
        nvDrawer.setCheckedItem(R.id.nav_first_fragment);
        selectDrawerItem(nvDrawer.getMenu().getItem(0));
    }

    //---------------------------------------------------------------------------------------------
    private ActionBarDrawerToggle setupDrawerToggle() {
        return new ActionBarDrawerToggle(this, dlDrawer, toolbar, R.string.drawer_open,  R.string.drawer_close);
    }
    private void setupDrawerContent(NavigationView navigationView) {
        navigationView.setNavigationItemSelectedListener(
                new NavigationView.OnNavigationItemSelectedListener() {
                    @Override
                    public boolean onNavigationItemSelected(MenuItem menuItem) {
                        selectDrawerItem(menuItem);
                        return true;
                    }
                });
    }
    public void selectDrawerItem(MenuItem menuItem) {
        // Create a new fragment and specify the planet to show based on
        // position
        Fragment fragment = null;

        Class fragmentClass;
        switch(menuItem.getItemId()) {
            case R.id.nav_first_fragment:
                fragmentClass = GamesListsFragment.class;
                break;
            case R.id.nav_second_fragment:
                fragmentClass = UserProfileFragment2.class;
                break;
            case R.id.nav_third_fragment:
                fragmentClass = RatingParentFragment.class;
                break;
            case R.id.nav_four_fragment:
                fragmentClass = AboutFragment.class;
                break;
            default:
                fragmentClass = GamesListsFragment.class;
        }

        try {
            fragment = (Fragment) fragmentClass.newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Insert the fragment by replacing any existing fragment
        FragmentManager fragmentManager = getSupportFragmentManager();
        fragmentManager.beginTransaction().replace(R.id.flContent, fragment).commit();

        // Highlight the selected item, update the title, and close the drawer
        menuItem.setChecked(true);
        setTitle(menuItem.getTitle());
        mDrawer.closeDrawers();
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // The action bar home/up action should open or close the drawer.
        switch (item.getItemId()) {
            case android.R.id.home:
                mDrawer.openDrawer(GravityCompat.START);
                return true;
        }
        if (drawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        drawerToggle.syncState();
    }
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        // Pass any configuration change to the drawer toggles
        drawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public View onCreateView(View parent, String name, Context context, AttributeSet attrs) {

        return super.onCreateView(parent, name, context, attrs);
    }

    //*********************************************************************************************

    private void registerBroadcastReceivers(){
        LocalBroadcastManager.getInstance(getApplicationContext()).registerReceiver(mUnauthorizedMessageReceiver, new IntentFilter(Const.BM_USER_UNAUTHTORIZED));
    }

    private BroadcastReceiver mUnauthorizedMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            StartLoginActivity();
            finish();
        }
    };

    private boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST)
                        .show();
            } else {
                Toast.makeText(getApplicationContext(),"Устроиство не поддерживает push уведомления", Toast.LENGTH_LONG);
                finish();
            }
            return false;
        }
        return true;
    }
    private void StartLoginActivity(){
        Intent intent = new Intent(this, LoginActivity.class);
        startActivity(intent);
    }
    private void StartSplashActivity(){
        Intent intent = new Intent(this, SplashActivity.class);
        startActivityForResult(intent, SPLASH_CHECK_AUTH_REQUEST);
    }
    public static void StartMainActivity(Activity currentActivity){
        Intent intent = new Intent(currentActivity, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        currentActivity.startActivity(intent);
        currentActivity.finish();
    }

    @Override
    public void onContentChanged() {
        super.onContentChanged();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        if(SPLASH_CHECK_AUTH_REQUEST==requestCode){
//            if(RESULT_CANCELED==resultCode){
//                StartLoginActivity();
//            }
//        }
    }
//    private Fragment getSelectedFragment(int position){
//        switch (position){
//            case 1:
//                GamesListsFragment gamesListsFragment = new GamesListsFragment();
//                return gamesListsFragment;
//            case 2:
//                UserProfileFragment2 userProfileFragment = new UserProfileFragment2();
//                return userProfileFragment;
//            case 3:
//                RatingParentFragment ratingParentFragment = new RatingParentFragment();
//                return ratingParentFragment;
//            case 4:
//                AboutFragment aboutFragment = new AboutFragment();
//                return aboutFragment;
//            default:
//                return PlaceholderFragment.newInstance(position);
//        }
//    }
//    @Override
//    public void onNavigationDrawerItemSelected(int position) {
//        // update the main content by replacing fragments
//        FragmentManager fragmentManager = getSupportFragmentManager();
//        fragmentManager.beginTransaction()
//                .add(R.id.container, getSelectedFragment(position+1))
//                .addToBackStack(null)
//                .commit();
//    }

//    public void onSectionAttached(int number) {
//        switch (number) {
//            case 1:
//                mTitle = getString(R.string.title_section1);
//                break;
//            case 2:
//                mTitle = getString(R.string.title_section2);
//                break;
//            case 3:
//                mTitle = getString(R.string.title_section3);
//                break;
//        }
//    }

    @Override
    public void onBackPressed() {
//        if(getSupportFragmentManager().getBackStackEntryCount()<=1){
//            getSupportFragmentManager().popBackStack();
//        }
        if(getSupportFragmentManager().getBackStackEntryCount()>0&&getSupportFragmentManager().getBackStackEntryAt(getSupportFragmentManager().getBackStackEntryCount()-1).getName()!=null&&
                getSupportFragmentManager().getBackStackEntryAt(getSupportFragmentManager().getBackStackEntryCount()-1).getName().equals("GameList")){
            for(Fragment fragment:getSupportFragmentManager().getFragments()){
                if(fragment instanceof GamesListsFragment){
                   ((GamesListsFragment) fragment).UpdateGamesLists();
                }
            }
        }
        super.onBackPressed();
    }

//    public void restoreActionBar() {
//        ActionBar actionBar = getSupportActionBar();
//        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD);
//        actionBar.setDisplayShowTitleEnabled(true);
//        actionBar.setTitle(mTitle);
////        actionBar.set
//    }


//    @Override
//    public boolean onCreateOptionsMenu(Menu menu) {
////        if (!mNavigationDrawerFragment.isDrawerOpen()) {
////            // Only show items in the action bar relevant to this screen
////            // if the drawer is not showing. Otherwise, let the drawer
////            // decide what to show in the action bar.
////            getMenuInflater().inflate(R.menu.main, menu);
////            restoreActionBar();
////            return true;
////        }
//        return super.onCreateOptionsMenu(menu);
//    }

//    @Override
//    public boolean onOptionsItemSelected(MenuItem item) {
//        // Handle action bar item clicks here. The action bar will
//        // automatically handle clicks on the Home/Up button, so long
//        // as you specify a parent activity in AndroidManifest.xml.
//        int id = item.getItemId();
//
//        //noinspection SimplifiableIfStatement
//        if (id == R.id.action_settings) {
//            return true;
//        }
//
//        return super.onOptionsItemSelected(item);
//    }

    /**
     * A placeholder fragment containing a simple view.
     */
//    public static class PlaceholderFragment extends Fragment {
//        /**
//         * The fragment argument representing the section number for this
//         * fragment.
//         */
//        private static final String ARG_SECTION_NUMBER = "section_number";
//
//        /**
//         * Returns a new instance of this fragment for the given section
//         * number.
//         */
//        public static PlaceholderFragment newInstance(int sectionNumber) {
//            PlaceholderFragment fragment = new PlaceholderFragment();
//            Bundle args = new Bundle();
//            args.putInt(ARG_SECTION_NUMBER, sectionNumber);
//            fragment.setArguments(args);
//            return fragment;
//        }
//
//        public PlaceholderFragment() {
//        }
//
//        @Override
//        public View onCreateView(LayoutInflater inflater, ViewGroup container,
//                                 Bundle savedInstanceState) {
//            View rootView = null;
//            switch (getArguments().getInt(ARG_SECTION_NUMBER)){
//                case 1:
//                    GamesListsFragment gamesListsFragment = new GamesListsFragment();
////                    FragmentManager fragmentManager = getSupportFragmentManager();
////                    fragmentManager.beginTransaction()
////                            .replace(R.id.container, gamesListsFragment)
////                            .addToBackStack(null)
////                            .commit();
////                    rootView = inflater.inflate(R.layout.fragment_my_games, container, false);
//
//                    break;
//                default:
//                    rootView = inflater.inflate(R.layout.fragment_main, container, false);
//            }
//
//            return rootView;
//        }
//
//        @Override
//        public void onAttach(Activity activity) {
//            super.onAttach(activity);
//            ((MainActivity) activity).onSectionAttached(
//                    getArguments().getInt(ARG_SECTION_NUMBER));
//        }
//    }

}
