package kz.aphion.brainfights.jobs;

import java.util.Calendar;

import kz.aphion.brainfights.persistents.user.User;
import play.Logger;
import play.db.jpa.JPA;
import play.jobs.Job;
import play.jobs.On;

@On("0 15 5 ? * SUN")
public class SaveHistoryJob extends Job {

	public void doJob(){
	
		try {
			Logger.info("Start update user history");
			Calendar date = Calendar.getInstance();
			
			JPA.em().createQuery("update User set lastStatisticsUpdate = :timeUpdate, lastWonGames = wonGames, " +
					"lastTotalGames = totalGames, lastLoosingGames = loosingGames, lastScore = score, " +
					"lastDrawnGames = drawnGames where deleted = 'FALSE'").setParameter("timeUpdate", date).executeUpdate();
			
			Logger.info("Finish update user history");
			
			Logger.info("Start update departments history");
			Calendar dateUpdateDep = Calendar.getInstance();
			
			JPA.em().createQuery("update Department set lastStatisticsUpdate = :timeUpdate, lastScore = score " +
					"where deleted = 'FALSE'").setParameter("timeUpdate", dateUpdateDep).executeUpdate();
			
			Logger.info("Finish update departments history");
			}
		catch (Exception e) {
			JPA.em().getTransaction().rollback();
			Logger.info(e.getMessage());
		}
	}
}
