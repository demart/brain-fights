package kz.aphion.brainfights.persistents.game;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;
import kz.aphion.brainfights.persistents.user.User;

/**
 * Друг в игре
 * 
 * @author artem.demidovich
 *
 */
//@Entity
//@Table(name="game_friend")
public class GameFriend extends PersistentObject {

	@Id
	@GeneratedValue(generator="game_friend_sequence")
	@SequenceGenerator(name="game_friend_sequence",sequenceName="game_friend_sequence", allocationSize=1)
	public Long id;
	public Long getId() { return id;}
	@Override
	public Object _key() { return getId(); }	

	@ManyToOne
	public User user;
	
	@ManyToOne
	public User friend;

}
