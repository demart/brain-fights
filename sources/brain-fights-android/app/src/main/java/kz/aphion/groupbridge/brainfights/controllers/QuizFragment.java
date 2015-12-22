package kz.aphion.groupbridge.brainfights.controllers;

import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.picasso.Picasso;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Timer;
import java.util.TimerTask;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionAnswerModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionModel;
import kz.aphion.groupbridge.brainfights.models.GameStatus;
import kz.aphion.groupbridge.brainfights.models.GamerQuestionAnswerResultModel;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.utils.Const;
import kz.aphion.groupbridge.brainfights.utils.Util;

/**
 * Created by alimjan on 29.11.2015.
 */
public class QuizFragment extends Fragment implements RestTask.RestTaskCallback {
    private static int TIMER_TIMEOUT=45;
    private int timerCount;
    GameRoundModel round;
    GameModel game;
    boolean fromGame = false;
    View v;
    RelativeLayout imageQuizLayout;
    RelativeLayout textQuizLayout;
    ImageView imageQuizImage;
    TextView imageQuizText;
    TextView imageQuizCategory;
    TextView textQuizText;
    TextView textQuizCategory;
    Button btnA1;
    Button btnA2;
    Button btnA3;
    Button btnA4;
    Button btns[] = new Button[4];
    GameRoundQuestionModel actualQuiz;
    ProgressBar progressBar;
    TextView opponentName;
    private Timer timer;
    private AnswerTimer answerTimer;
    boolean prevAnswerSaved = true;
    Animation animationFade;
    boolean gameEnd = false;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_quiz, container, false);
        setComponents();
        loadQuiz();
        return v;
    }

    private void loadQuiz() {
        actualQuiz = findActualQuiz();
        if(actualQuiz!=null){
            loadActualQuiz(actualQuiz);
        }else {
          //  if(fromGame)getFragmentManager().popBackStack();
          //  else {
                GameFragment gameFragment = new GameFragment();
                gameFragment.gameId = game.id;
                gameFragment.gameEndNotification = gameEnd;
                FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                fragmentManager.beginTransaction()
                        .add(R.id.container, gameFragment)
                        .commit();
           // }

        }
    }

    private void loadActualQuiz(GameRoundQuestionModel actualQuiz) {
        if(actualQuiz!=null){
            opponentName.setVisibility(View.GONE);
            if(animationFade!=null){
                opponentName.clearAnimation();
            }
            v.setVisibility(View.GONE);
            switch (actualQuiz.type){
                case IMAGE:
                    textQuizLayout.setVisibility(View.GONE);
                    imageQuizLayout.setVisibility(View.VISIBLE);
                    imageQuizText.setText(actualQuiz.text);
                    imageQuizCategory.setText(round.category.name);
                    try {
                        if(actualQuiz.imageUrl!=null){
                            imageQuizImage.setImageBitmap(Picasso.with(getContext()).load(Const.BASE_URL+actualQuiz.imageUrl).get());
                        }else if(actualQuiz.imageUrlBase64!=null){
                            try {
                                imageQuizImage.setImageBitmap(Picasso.with(getContext()).load(Const.BASE_URL+new String(Base64.decode(actualQuiz.imageUrlBase64, Base64.DEFAULT), "UTF-8")).get());
                            } catch (UnsupportedEncodingException e) {
                                e.printStackTrace();
                            }
                        }else{

                            //TODO: загрузка цвета
                        }
                        loadAnswersToView(actualQuiz);
                        startTimer();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
                case TEXT:
                    textQuizLayout.setVisibility(View.VISIBLE);
                    imageQuizLayout.setVisibility(View.GONE);
                    textQuizText.setText(actualQuiz.text);
                    textQuizCategory.setText(round.category.name);
                    loadAnswersToView(actualQuiz);
                    startTimer();
                    break;
            }
            v.setVisibility(View.VISIBLE);
        }
    }

    private void startTimer() {
        progressBar.setProgress(TIMER_TIMEOUT);
        progressBar.setVisibility(View.VISIBLE);
        timerCount = TIMER_TIMEOUT;
        if (timer != null) {
            timer.cancel();
        }
        timer = new Timer();
        answerTimer = new AnswerTimer();
        timer.schedule(answerTimer, 0, 1000);
    }

    private void loadAnswersToView(GameRoundQuestionModel actualQuiz) {
        if(actualQuiz.answers.size()>0) {
            btnA1.setText(actualQuiz.answers.get(0).text);
            btnA1.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
        }
        if(actualQuiz.answers.size()>1) {
            btnA2.setText(actualQuiz.answers.get(1).text);
            btnA2.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
        }
        if(actualQuiz.answers.size()>2) {
            btnA3.setText(actualQuiz.answers.get(2).text);
            btnA3.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
        }
        if(actualQuiz.answers.size()>3) {
            btnA4.setText(actualQuiz.answers.get(3).text);
            btnA4.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
        }
        setAnswerButtonState(true);
    }

    private GameRoundQuestionModel findActualQuiz(){
        for(GameRoundQuestionModel quiz:round.questions){
            if(quiz.answer==null){
                return quiz;
            }
        }
        return null;
    }
    private void nextQuestion() {
        if(prevAnswerSaved){
            loadQuiz();
        }
    }
    private int findAnswerById(Long id){
        for(GameRoundQuestionAnswerModel answerModel:actualQuiz.answers){
            if(answerModel.id.equals(id)){
                return actualQuiz.answers.indexOf(answerModel);
            }
        }
        return -1;
    }
    private int findCorrectAnswer(){
        for(GameRoundQuestionAnswerModel answerModel:actualQuiz.answers){
            if(answerModel.isCorrect){
                return actualQuiz.answers.indexOf(answerModel);
            }
        }
        return -1;
    }
    private void setAnswer(int i) {
        timer.cancel();
        setAnswerButtonState(false);
        GameRoundQuestionAnswerModel answer = actualQuiz.answers.get(i);
        actualQuiz.answer = answer;
        saveAnswer(answer);
        if(answer.isCorrect){
            btns[i].setBackgroundColor(getResources().getColor(R.color.ttk_green));
        }else {
            btns[i].setBackgroundColor(getResources().getColor(R.color.ttk_red));
            btns[findCorrectAnswer()].setBackgroundColor(getResources().getColor(R.color.ttk_green));
            Animation animation1 = AnimationUtils.loadAnimation(getContext(), R.anim.blink);
            btns[findCorrectAnswer()].startAnimation(animation1);
        }
        if(actualQuiz.oponentAnswer!=null){
            int p = findAnswerById(actualQuiz.oponentAnswer.id);
            if(p>=0)
            viewOpponentName(btns[p]);
        }

    }

    private void viewOpponentName(Button btn) {
        int row = ((TableRow)btn.getParent()).getTop();
        int btnHeight = btn.getMeasuredHeight();
        int btnWidth = btn.getMeasuredWidth();
        float btnX = btn.getX();
        float btnY = row;//btn.getY();
        opponentName.setVisibility(View.VISIBLE);
        opponentName.setText(game.oponent.user.getName());
        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) opponentName.getLayoutParams();
        layoutParams.width = btnWidth;
        opponentName.setLayoutParams(layoutParams);
        int txtHeight = opponentName.getMeasuredHeight();
        opponentName.setY((btnY+btnHeight/2)-txtHeight / 2);
        opponentName.setX(btnX);
        opponentName.startAnimation(animationFade);
    }

    private void saveAnswer(GameRoundQuestionAnswerModel answer) {
        prevAnswerSaved = false;
        RestTask task = new RestTask(getContext(), this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.SET_ANSWER);
        params.gameId = game.id;
        params.roundId = round.id;
        params.questionId = actualQuiz.id;
        params.answerId = answer.id;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }
    private void setAnswerButtonState(boolean state){
        for (Button btn:btns){
            btn.setEnabled(state);
        }
    }
    private void timeoutAnswer(){
        timer.cancel();
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                setAnswerButtonState(false);
                Toast.makeText(getContext(), "Вы не успели ответить на вопрос!", Toast.LENGTH_SHORT).show();
            }
        });

        GameRoundQuestionAnswerModel answer = new GameRoundQuestionAnswerModel();
        answer.id = Long.valueOf(-1);
        answer.isCorrect = false;
        saveAnswer(answer);
        actualQuiz.answer = answer;

    }
    private void setComponents() {
        imageQuizLayout = (RelativeLayout) v.findViewById(R.id.quiz_image_quiz_layout);
        textQuizLayout = (RelativeLayout) v.findViewById(R.id.quiz_text_quiz_layout);
        imageQuizImage = (ImageView) imageQuizLayout.findViewById(R.id.quiz_image);
        imageQuizCategory = (TextView) imageQuizLayout.findViewById(R.id.quiz_image_quiz_category);
        imageQuizText = (TextView)imageQuizLayout.findViewById(R.id.quiz_image_quiz_text);
        textQuizCategory = (TextView) textQuizLayout.findViewById(R.id.quiz_text_quiz_category);
        textQuizText = (TextView)textQuizLayout.findViewById(R.id.quiz_text_quiz_text);
        btnA1 = (Button)v.findViewById(R.id.quiz_answer1);
        btnA2 = (Button)v.findViewById(R.id.quiz_answer2);
        btnA3 = (Button)v.findViewById(R.id.quiz_answer3);
        btnA4 = (Button)v.findViewById(R.id.quiz_answer4);
        btns = new Button[]{btnA1,btnA2,btnA3,btnA4};
        progressBar = (ProgressBar) v.findViewById(R.id.quiz_progressBar);
        progressBar.setMax(TIMER_TIMEOUT);
        opponentName = (TextView) v.findViewById(R.id.quiz_answer_opponent_name);
        imageQuizLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                nextQuestion();
            }
        });
        textQuizLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                nextQuestion();
            }
        });
        btnA1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(0);
            }
        });
        btnA2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(1);
            }
        });
        btnA3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(2);
            }
        });
        btnA4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(3);
            }
        });
        animationFade = AnimationUtils.loadAnimation(getContext(), R.anim.fade);
        animationFade.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                opponentName.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if (taskResult.getTaskType() == RestTask.TaskType.SET_ANSWER) {
            if (taskResult.getTaskStatus() == RestTask.TaskStatus.SUCCESS) {
                StatusSingle<GamerQuestionAnswerResultModel> status = (StatusSingle) taskResult.getResponseData();
                if (status.getStatus() == ResponseStatus.SUCCESS) {
                    prevAnswerSaved = true;
                    if(status.getData().gameStatus.equals(GameStatus.FINISHED)){
                        gameEnd=true;
                    }
                }
            }
        }
    }

    class AnswerTimer extends TimerTask {

        @Override
        public void run() {
            if(timerCount!=0) {
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        progressBar.setProgress(timerCount);
                    }
                });
                timerCount--;
            }
            else{
                timeoutAnswer();
            }
        }
    }

}
