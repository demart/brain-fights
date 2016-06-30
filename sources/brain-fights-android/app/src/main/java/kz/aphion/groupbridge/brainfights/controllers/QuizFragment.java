package kz.aphion.groupbridge.brainfights.controllers;

import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.AnimationUtils;
import android.view.animation.TranslateAnimation;
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
import kz.aphion.groupbridge.brainfights.animation.ButtonAnswerAnimation;
import kz.aphion.groupbridge.brainfights.components.FlipAnimation;
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
    ButtonAnswerAnimation btn1Anim;
    ButtonAnswerAnimation btn2Anim;
    ButtonAnswerAnimation btn3Anim;
    ButtonAnswerAnimation btn4Anim;
    View q1State;
    View q2State;
    View q3State;
    View[] quizesStates;
    Button btns[] = new Button[4];
    GameRoundQuestionModel actualQuiz;
    ProgressBar progressBar;
    TextView opponentName;
    private Timer timer;
    private AnswerTimer answerTimer;
    boolean prevAnswerSaved = true;
    Animation animationFade;
    boolean gameEnd = false;
//    Animation animationFlipIn = null;
//    Animation animationFlipOut = null;
    RelativeLayout animLayout;
//    AnimationSet animateSlideQuiz;
    FlipAnimation categoryLayoutAnim;
    RelativeLayout activeLayout;
    Animation blinkCurrentQuizStateAnim;
    TextView labelNext;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_quiz, container, false);

//        animationFlipIn = AnimationUtils.loadAnimation(getContext(), R.anim.category_flip_in);
//        animationFlipOut = AnimationUtils.loadAnimation(getContext(), R.anim.category_flip_out);
//        animateSlideQuiz = new AnimationSet(true);
//        animateSlideQuiz.setFillAfter(true);
//
////        animateSlideQuiz.addAnimation(animationFlipOut);
////        animateSlideQuiz.addAnimation(animationFlipIn);
//        DisplayMetrics metrics = new DisplayMetrics();
//        getActivity().getWindowManager().getDefaultDisplay().getMetrics(metrics);
//        final float screen_width_half = metrics.widthPixels;
//        final float distance = screen_width_half;
//        Animation animation =
//                new TranslateAnimation(0, -distance, +100, 0);
//        animation.setDuration(1000);
//        animation.setStartOffset(1000);
////        animation.setRepeatCount(0);
////        animation.setFillAfter(false);
//        animateSlideQuiz.addAnimation(animation);
//        Animation animation2 =
//                new TranslateAnimation(distance, 0, 0, 0);
////        animation2.setStartOffset(1000);
//        animation2.setDuration(1000);
////        animation2.setFillAfter(false);
////        animation2.setRepeatCount(0);
//        animateSlideQuiz.addAnimation(animation2);
//        animationFlipOut.setAnimationListener(new Animation.AnimationListener() {
//            @Override
//            public void onAnimationStart(Animation animation) {
//
//            }
//
//            @Override
//            public void onAnimationEnd(Animation animation) {
//                animLayout.startAnimation(animationFlipIn);
//            }
//
//            @Override
//            public void onAnimationRepeat(Animation animation) {
//
//            }
//        });

        setComponents();
        categoryLayoutAnim = new FlipAnimation(textQuizLayout, textQuizLayout);
        loadQuiz();
        return v;
    }

    private void loadQuiz() {
        if(actualQuiz!=null&&actualQuiz.answer==null){
            return;
        }
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
                        .add(R.id.flContent, gameFragment)
                        .commit();
           // }

        }
    }
    private void setQuizesState(){
        if(round!=null&&round.questions!=null&&round.questions.size()==3){
            for(int i=0;i<3;i++){
                quizesStates[i].clearAnimation();
                if(round.questions.get(i).answer!=null){
                    if(round.questions.get(i).answer.isCorrect){
                        quizesStates[i].setBackgroundColor(getResources().getColor(R.color.ttk_green));
                    }else{
                        quizesStates[i].setBackgroundColor(getResources().getColor(R.color.ttk_red));
                    }
                }else{
                    quizesStates[i].setBackgroundColor(getResources().getColor(R.color.ttk_orange));
                    quizesStates[i].startAnimation(blinkCurrentQuizStateAnim);
                    return;
                }
            }
        }
    }
    private void loadActualQuiz(GameRoundQuestionModel actualQuiz) {
        if(actualQuiz!=null){
            labelNext.setVisibility(View.GONE);
            opponentName.setVisibility(View.GONE);
            if(animationFade!=null){
                opponentName.clearAnimation();
            }
            v.setVisibility(View.GONE);
            setQuizesState();
            switch (actualQuiz.type){
                case IMAGE:
                    if(activeLayout!=null){
                        categoryLayoutAnim = new FlipAnimation(activeLayout,imageQuizLayout,imageQuizText,actualQuiz.text,null);
                        categoryLayoutAnim.setDuration(500);
                        imageQuizLayout.startAnimation(categoryLayoutAnim);
                    }else{
                        imageQuizText.setText(actualQuiz.text);
                    }
                    textQuizLayout.setVisibility(View.GONE);
                    imageQuizLayout.setVisibility(View.VISIBLE);
                    activeLayout = imageQuizLayout;
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
                    if(activeLayout!=null){
                        categoryLayoutAnim = new FlipAnimation(activeLayout,textQuizLayout, textQuizText, actualQuiz.text, null);
                        categoryLayoutAnim.setDuration(500);
                        textQuizLayout.startAnimation(categoryLayoutAnim);
                    }else{
                        textQuizText.setText(actualQuiz.text);
                    }
                    animLayout = textQuizLayout;
                    textQuizLayout.setVisibility(View.VISIBLE);
                    imageQuizLayout.setVisibility(View.GONE);

                    textQuizCategory.setText(round.category.name);
                    activeLayout = textQuizLayout;
//                    textQuizCategory.setBackgroundResource(0);
//                    textQuizCategory.invalidate();
//                    textQuizCategory.refreshDrawableState();
//                    textQuizCategory.setBackgroundResource(R.drawable.category_shape);
//                    textQuizCategory.refreshDrawableState();
//                    textQuizCategory.invalidate();

                    loadAnswersToView(actualQuiz);
                    startTimer();
//                    textQuizLayout.startAnimation(animationFlipIn);
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
        btnA1.setAlpha(0);
        btnA1.setEnabled(false);
        btnA2.setAlpha(0);
        btnA2.setEnabled(false);
        btnA3.setAlpha(0);
        btnA3.setEnabled(false);
        btnA4.setAlpha(0);
        btnA4.setEnabled(false);
        if(actualQuiz.answers.size()>0) {
            System.out.println("answer:"+actualQuiz.answers.get(0).text);
            if(actualQuiz.answers.get(0).text!=null)actualQuiz.answers.get(0).text = actualQuiz.answers.get(0).text.trim();
            if(btn1Anim!=null){
                btn1Anim.start(actualQuiz.answers.get(0).text);
            }else{
                btnA1.setText(actualQuiz.answers.get(0).text);
                btn1Anim = new ButtonAnswerAnimation(btnA1,true, getActivity());
            }
            btnA1.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
            btnA1.setAlpha(1);
            btnA1.setEnabled(true);
        }
        if(actualQuiz.answers.size()>1) {
            System.out.println("answer:"+actualQuiz.answers.get(1).text);
            if(actualQuiz.answers.get(1).text!=null)actualQuiz.answers.get(1).text = actualQuiz.answers.get(1).text.trim();
            if(btn2Anim!=null){
                btn2Anim.start(actualQuiz.answers.get(1).text);
            }else{
                btnA2.setText(actualQuiz.answers.get(1).text);
                btn2Anim = new ButtonAnswerAnimation(btnA2,false, getActivity());
            }
//            btnA2.setText(actualQuiz.answers.get(1).text);
            btnA2.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
            btnA2.setAlpha(1);
            btnA2.setEnabled(true);
        }
        if(actualQuiz.answers.size()>2) {
            System.out.println("answer:"+actualQuiz.answers.get(2).text);
            if(actualQuiz.answers.get(2).text!=null)actualQuiz.answers.get(2).text = actualQuiz.answers.get(2).text.trim();
            if(btn3Anim!=null){
                btn3Anim.start(actualQuiz.answers.get(2).text);
            }else{
                btnA3.setText(actualQuiz.answers.get(2).text);
                btn3Anim = new ButtonAnswerAnimation(btnA3,true, getActivity());
            }
//            btnA3.setText(actualQuiz.answers.get(2).text);
            btnA3.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
            btnA3.setAlpha(1);
            btnA3.setEnabled(true);
        }
        if(actualQuiz.answers.size()>3) {
            System.out.println("answer:"+actualQuiz.answers.get(3).text);
            if(actualQuiz.answers.get(3).text!=null)actualQuiz.answers.get(3).text = actualQuiz.answers.get(3).text.trim();
            if(btn4Anim!=null){
                btn4Anim.start(actualQuiz.answers.get(3).text);
            }else{
                btnA4.setText(actualQuiz.answers.get(3).text);
                btn4Anim = new ButtonAnswerAnimation(btnA4,false, getActivity());
            }
//            btnA4.setText(actualQuiz.answers.get(3).text);
            btnA4.setAlpha(1);
            btnA4.setEnabled(true);
            btnA4.setBackgroundColor(getResources().getColor(R.color.ttk_lightGreen));
        }
        setAnswerButtonPostion(btnA1);
        setAnswerButtonPostion(btnA2);
        setAnswerButtonPostion(btnA3);
        setAnswerButtonPostion(btnA4);
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
    private void setAnswerButtonPostion(Button btn){
        if(btn.getTop()!=15){
//            TableRow.LayoutParams params = (TableRow.LayoutParams) btn.getLayoutParams();
//
//            System.out.println("TOOP WRONG");
            btn.setTop(15);
        }
    }
    private void setAnswer(int i) {
        timer.cancel();
        setAnswerButtonState(false);
        labelNext.setText("Сохранение ответа...");
        labelNext.setVisibility(View.VISIBLE);
        if(i<actualQuiz.answers.size()) {
            GameRoundQuestionAnswerModel answer = actualQuiz.answers.get(i);
            actualQuiz.answer = answer;
            saveAnswer(answer);
            if (answer.isCorrect) {
                btns[i].setBackgroundColor(getResources().getColor(R.color.ttk_green));
            } else {
                btns[i].setBackgroundColor(getResources().getColor(R.color.ttk_red));
                btns[findCorrectAnswer()].setBackgroundColor(getResources().getColor(R.color.ttk_green));
                Animation animation1 = AnimationUtils.loadAnimation(getContext(), R.anim.blink);
                btns[findCorrectAnswer()].startAnimation(animation1);
            }
            if (actualQuiz.oponentAnswer != null) {
                int p = findAnswerById(actualQuiz.oponentAnswer.id);
                if (p >= 0)
                    viewOpponentName(btns[p]);
            }
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
        q1State = v.findViewById(R.id.q1_state);
        q2State = v.findViewById(R.id.q2_state);
        q3State = v.findViewById(R.id.q3_state);
        quizesStates = new View[]{q1State, q2State, q3State};
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
                setAnswerButtonPostion(btnA1);
            }
        });
        btnA1.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {

                if(top!=15){
                    v.setTop(15);
                    TableRow.LayoutParams params = (TableRow.LayoutParams) v.getLayoutParams();
                    params.setMargins(15,15,15,15);
                    params.height=360;
                    v.invalidate();;
                }
            }
        });
        btnA2.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                if(top!=15){
                    v.setTop(15);
                    TableRow.LayoutParams params = (TableRow.LayoutParams) v.getLayoutParams();
                    params.setMargins(15,15,15,15);
                    params.height=360;
                    v.invalidate();
                }
            }
        });
        btnA3.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                if(top!=15){
                    v.setTop(15);
                    TableRow.LayoutParams params = (TableRow.LayoutParams) v.getLayoutParams();
                    params.setMargins(15,15,15,15);
                    params.height=360;
                    v.invalidate();
                }
            }
        });
        btnA4.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                if(top!=15){
                    v.setTop(15);
                    TableRow.LayoutParams params = (TableRow.LayoutParams) v.getLayoutParams();
                    params.setMargins(15,15,15,15);
                    params.height=360;
                    v.invalidate();
                }
            }
        });
        btnA2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(1);
                setAnswerButtonPostion(btnA2);
            }
        });
        btnA3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(2);
                setAnswerButtonPostion(btnA3);
            }
        });
        btnA4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAnswer(3);
                setAnswerButtonPostion(btnA4);
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
        blinkCurrentQuizStateAnim = AnimationUtils.loadAnimation(getContext(), R.anim.blink_quiz_state);
        labelNext = (TextView) v.findViewById(R.id.quiz_next_label);
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if (taskResult.getTaskType() == RestTask.TaskType.SET_ANSWER) {
            if (taskResult.getTaskStatus() == RestTask.TaskStatus.SUCCESS) {
                StatusSingle<GamerQuestionAnswerResultModel> status = (StatusSingle) taskResult.getResponseData();
                if (status.getStatus() == ResponseStatus.SUCCESS) {
                    labelNext.setText("Нажмите на вопрос для продолжения...");
                    prevAnswerSaved = true;
                    if(status.getData().gameStatus.equals(GameStatus.FINISHED)){
                        gameEnd=true;
                    }
                }
                else{
                    if(status!=null&&status.getErrorCode()!=null&&status.getErrorCode().equals("002")){
                        GameFragment gameFragment = new GameFragment();
                        gameFragment.gameId = game.id;
                        gameFragment.gameEndNotification = gameEnd;
                        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                        fragmentManager.beginTransaction()
                                .add(R.id.flContent, gameFragment)
                                .commit();
                    }
                }
            }else{
            }
        }else{

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
