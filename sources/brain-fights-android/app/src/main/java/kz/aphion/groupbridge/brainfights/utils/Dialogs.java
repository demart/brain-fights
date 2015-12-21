package kz.aphion.groupbridge.brainfights.utils;

import android.app.Activity;
import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;


import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionAnswerModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionModel;
import kz.aphion.groupbridge.brainfights.models.GameStatus;
import kz.aphion.groupbridge.brainfights.models.GamerStatus;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;

/**
 * Created by alimjan on 03.12.2015.
 */
public class Dialogs {
    public static void GameEndNotificationDialog(Activity activity, GameModel game, RestTask.RestTaskCallback callback){
        if(!(game.me.status.equals(GamerStatus.WINNER)||game.me.status.equals(GamerStatus.DRAW)||game.me.status.equals(GamerStatus.LOOSER)||game.me.status.equals(GamerStatus.SURRENDED)||game.me.status.equals(GamerStatus.OPONENT_SURRENDED)))return;
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        LayoutInflater inflater = activity.getLayoutInflater();
        View v = inflater.inflate(R.layout.dialog_end_game_notify, null);
        TextView gameStatus = (TextView) v.findViewById(R.id.deg_game_status);
        TextView opponentName = (TextView) v.findViewById(R.id.deg_opponent_name);
        TextView rating = (TextView)v.findViewById(R.id.deg_rating);
        String buttonText=null;
        switch (game.me.status){
            case WINNER:
                gameStatus.setText("ПОБЕДА!");
                gameStatus.setTextColor(activity.getResources().getColor(R.color.ttk_green));
                buttonText="Хорошо";
                break;
            case OPONENT_SURRENDED:
                gameStatus.setText("ПОБЕДА!\n противник сдался!");
                gameStatus.setTextColor(activity.getResources().getColor(R.color.ttk_green));
                buttonText="Хорошо";
                break;
            case DRAW:
                gameStatus.setText("Ничья.");
                gameStatus.setTextColor(activity.getResources().getColor(R.color.ttk_darkGary));
                buttonText="Закрыть";
                break;
            case LOOSER:
                gameStatus.setText("Поражение.");
                gameStatus.setTextColor(activity.getResources().getColor(R.color.ttk_red));
                buttonText="Жаль";
                break;
            case SURRENDED:
                gameStatus.setText("Вы сдались");
                gameStatus.setTextColor(activity.getResources().getColor(R.color.ttk_red));
                buttonText="Жаль";
                break;
        }
        opponentName.setText(game.oponent.user.getName());
        rating.setText("Рейтинг:" + String.valueOf(game.me.resultScore)); //TODO: Исправить на рейтинг, вроде исправил)
        builder.setView(v);
        builder.setPositiveButton(buttonText, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {

            }
        });
        builder.create().show();
        RestTask task = new RestTask(activity.getApplicationContext(), callback);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.SET_AS_VIEWED_GAME_RESULT);
        params.gameId = game.id;
        params.gamerId = game.me.id;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }
    public static void ViewQuizNotificationDialog(Activity activity, GameRoundQuestionModel quiz){
        if(quiz==null)return;
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        LayoutInflater inflater = activity.getLayoutInflater();
        View v = inflater.inflate(R.layout.dialog_view_quiz, null);
        TextView quizText = (TextView) v.findViewById(R.id.dvq_quiz);
        TextView rightAnswer = (TextView) v.findViewById(R.id.dvq_right_answer);
        TextView meAnswer = (TextView)v.findViewById(R.id.dvq_me_answer);
        TextView opponentAnswer = (TextView)v.findViewById(R.id.dvq_opponent_answer);
        quizText.setText(quiz.text);
        GameRoundQuestionAnswerModel rightAnswerModel = findCorrectAnswer(quiz.answers);
        if(rightAnswerModel!=null)
        rightAnswer.setText(rightAnswerModel.text);
        if(quiz.answer!=null){
            meAnswer.setText(quiz.answer.text);
            if(quiz.answer.isCorrect){
                meAnswer.setTextColor(activity.getResources().getColor(R.color.ttk_green));
            }else meAnswer.setTextColor(activity.getResources().getColor(R.color.ttk_red));
        }else {
            meAnswer.setText("-");
        }
        if(quiz.oponentAnswer!=null){
            opponentAnswer.setText(quiz.oponentAnswer.text);
            if(quiz.oponentAnswer.isCorrect){
                opponentAnswer.setTextColor(activity.getResources().getColor(R.color.ttk_green));
            }else opponentAnswer.setTextColor(activity.getResources().getColor(R.color.ttk_red));
        }else {
            opponentAnswer.setText("-");
        }
        builder.setView(v);
        builder.setPositiveButton(R.string.close, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {

            }
        });
        builder.create().show();
    }
    private static GameRoundQuestionAnswerModel findCorrectAnswer(List<GameRoundQuestionAnswerModel> answers){
        for(GameRoundQuestionAnswerModel answerModel:answers){
            if(answerModel.isCorrect){
                return answerModel;
            }
        }
        return null;
    }
}
