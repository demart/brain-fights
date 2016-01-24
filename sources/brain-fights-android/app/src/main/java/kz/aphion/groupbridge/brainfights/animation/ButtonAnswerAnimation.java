package kz.aphion.groupbridge.brainfights.animation;

import android.app.Activity;
import android.util.DisplayMetrics;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.Button;

/**
 * Created by alimjan on 30.12.2015.
 */
public class ButtonAnswerAnimation {
    Animation animation1;
    Animation animation2;
    Button btn;
    String answerText;
    public ButtonAnswerAnimation(Button btn, boolean left, Activity activity){
        this.btn = btn;

        DisplayMetrics metrics = new DisplayMetrics();
        activity.getWindowManager().getDefaultDisplay().getMetrics(metrics);
        final float screen_width_half = metrics.widthPixels/2;
        final float distance = screen_width_half;
        if(left) {
            animation1 = new TranslateAnimation(0, -distance, 0, 0);
            animation2 = new TranslateAnimation(-distance, 0, 0, 0);
        }else{
            animation1 = new TranslateAnimation(0, distance, 0 , 0 );
            animation2 = new TranslateAnimation(distance,0,0,0);
        }
        animation1.setDuration(350);
        animation2.setDuration(350);
        animation1.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                ButtonAnswerAnimation.this.btn.setText(answerText);
                ButtonAnswerAnimation.this.btn.startAnimation(animation2);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }
    public void start(String answerText){
        this.answerText = answerText;
        btn.startAnimation(animation1);
    }
}
