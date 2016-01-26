package kz.aphion.groupbridge.brainfights.adapters;

import android.content.res.ColorStateList;
import android.graphics.Color;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionAnswerModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundStatus;
import kz.aphion.groupbridge.brainfights.models.GameStatus;
import kz.aphion.groupbridge.brainfights.models.GamerStatus;
import kz.aphion.groupbridge.brainfights.utils.Colors;

/**
 * Created by alimjan on 18.11.2015.
 */
public class GameRoundRecyclerAdapter extends RecyclerView.Adapter<GameRoundRecyclerAdapter.ViewHolder>{
    public static final int ROUND_COUNT=6;
    public static final int QUIZ_COUNT=3;
    private final GameModel game;
    private final int layout;
    private final GameRoundCallback callback;
    int rowHeight=0;


    public GameRoundRecyclerAdapter(int layout, GameModel game, GameRoundCallback callback, int viewSize){
        this.layout = layout;
        this.game = game;
        this.callback = callback;
        this.rowHeight = viewSize/ROUND_COUNT;


    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        RecyclerView.LayoutParams params = (RecyclerView.LayoutParams) v.getLayoutParams();
        params.height = rowHeight;
        v.setLayoutParams(params);
        return new ViewHolder(v, callback);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        holder.setRoundNumber(position);
        if(game.gameRounds!=null&&game.gameRounds.size()>position){ //Если такой раунд уже есть
            GameRoundModel round = game.gameRounds.get(position);
            holder.round = round;
            if(round.status.equals(GameRoundStatus.WAITING_ANSWER)){
                if(game.me.status.equals(GamerStatus.WAITING_OPONENT)){
                    holder.roundCategoryName.setText(round.categoryName);
                    if(round.questions!=null&&round.questions.size()>0&&round.questions.get(0).answer!=null){
                        setAnswers(round, holder, true);
                    }else {
                        holder.me_quiz_layout.setVisibility(View.GONE);
                    }
                    holder.me_button_game_layout.setVisibility(View.GONE);
                    holder.opponent_quiz_layout.setVisibility(View.GONE);
                    holder.opponent_label_game_layout.setVisibility(View.VISIBLE);
                }else if(game.me.status.equals(GamerStatus.WAITING_OWN_DECISION)){

                }else if(game.me.status.equals(GamerStatus.WAITING_ROUND)){

                }else if(game.me.status.equals(GamerStatus.WAITING_ANSWERS)){
                    holder.roundCategoryName.setText(round.category.name);
                    holder.opponent_quiz_layout.setVisibility(View.GONE);
                    holder.me_quiz_layout.setVisibility(View.GONE);
                    holder.opponent_label_game_layout.setVisibility(View.GONE);
                    holder.me_button_game_layout.setVisibility(View.VISIBLE);
                }

            }else if(round.status.equals(GameRoundStatus.COMPLETED)){
                holder.roundCategoryName.setText(round.category.name);
                setAnswers(round,holder, true);
                setAnswers(round,holder, false);
                holder.me_quiz_layout.setVisibility(View.VISIBLE);
                holder.opponent_quiz_layout.setVisibility(View.VISIBLE);
                holder.me_button_game_layout.setVisibility(View.GONE);
                holder.opponent_label_game_layout.setVisibility(View.GONE);
            }
        }else{ //Если такого раунда еше нет
            holder.opponent_label_game_layout.setVisibility(View.GONE);
            holder.me_button_game_layout.setVisibility(View.GONE);
            switch (game.me.status){
                case WAITING_OPONENT:
                    if(game.gameRounds==null){
                        if(position==0)
                        holder.opponent_label_game_layout.setVisibility(View.VISIBLE);
                    }else {
                        if(position==game.gameRounds.size()){
                            if(game.gameRounds.get(position-1).status.equals(GameRoundStatus.COMPLETED))
                            holder.opponent_label_game_layout.setVisibility(View.VISIBLE);
                        }
                    }
                    break;
                case WAITING_ROUND:
                    if(game.gameRounds==null){
                        if(position==0)
                            holder.me_button_game_layout.setVisibility(View.VISIBLE);
                    }else {
                        if(position==game.gameRounds.size()){
                            if(game.gameRounds.get(position-1).status.equals(GameRoundStatus.COMPLETED))
                            holder.me_button_game_layout.setVisibility(View.VISIBLE);
                        }
                    }
                    break;
            }
            holder.roundCategoryName.setText("");
            holder.me_quiz_layout.setVisibility(View.GONE);
            holder.opponent_quiz_layout.setVisibility(View.GONE);


        }

    }

    @Override
    public int getItemCount() {
        return ROUND_COUNT;
    }
    public void setAnswers(GameRoundModel round,ViewHolder holder, boolean me){
        if(me)
            for(int i=0;i<QUIZ_COUNT;i++){
                setAnswer(round.questions.get(i).answer,holder.me_quiz[i]);
            }
        else
            for(int i=0;i<QUIZ_COUNT;i++){
                setAnswer(round.questions.get(i).oponentAnswer,holder.opponent_quiz[i]);
            }

    }
//    public void setAnswer(GameRoundQuestionAnswerModel answer, FloatingActionButton btn){
//        if(answer!=null)
//            if(answer.isCorrect){
//                btn.setBackgroundTintList(Colors.correctAnswerColors);
//            }else {
//                btn.setBackgroundTintList(Colors.incorrectAnswerColors);
//            }
//        else
//            btn.setBackgroundTintList(Colors.noAnswerColors);
//    }
    public void setAnswer(GameRoundQuestionAnswerModel answer, Button btn){
        if(answer!=null)
            if(answer.isCorrect){
                btn.setBackgroundResource(R.color.ttk_green);
            }else {
                btn.setBackgroundResource(R.color.ttk_red);
            }
        else
            btn.setBackgroundResource(R.color.ttk_darkGary);
    }


    public static class ViewHolder extends RecyclerView.ViewHolder {

        public void setRoundNumber(int roundNumber) {
            roundName.setText("РАУНД "+(roundNumber+1));
            this.roundNumber = roundNumber;
        }
        GameRoundModel round;
        private int roundNumber;
        TextView roundName;
        TextView roundCategoryName;
//        FloatingActionButton me_q1;
//        FloatingActionButton me_q2;
//        FloatingActionButton me_q3;
        Button me_q1;
        Button me_q2;
        Button me_q3;
//        FloatingActionButton[] me_quiz;
//        FloatingActionButton[] opponent_quiz;
        Button[] me_quiz;
        Button[] opponent_quiz;
//        FloatingActionButton opponent_q1;
//        FloatingActionButton opponent_q2;
//        FloatingActionButton opponent_q3;
        Button opponent_q1;
        Button opponent_q2;
        Button opponent_q3;
        LinearLayout me_quiz_layout;
        LinearLayout opponent_quiz_layout;
        CardView me_card_quiz;
        CardView opponent_card_quiz;
        LinearLayout me_button_game_layout;
        LinearLayout opponent_label_game_layout;
        Button btnGame;
        View view;

        public ViewHolder(View itemView, final GameRoundCallback callback) {
            super(itemView);
            view = itemView;
            roundName = (TextView) itemView.findViewById(R.id.game_round_name);
            roundCategoryName = (TextView) itemView.findViewById(R.id.game_round_theme);
            me_card_quiz = (CardView) itemView.findViewById(R.id.card_quiz_me);
            opponent_card_quiz = (CardView) itemView.findViewById(R.id.card_quiz_opponent);
            me_quiz_layout = (LinearLayout) me_card_quiz.findViewById(R.id.card_quiz_quiz_layout);
//            me_q1 = (FloatingActionButton) me_quiz_layout.findViewById(R.id.card_quiz_button_quiz1);
//            me_q2 = (FloatingActionButton) me_quiz_layout.findViewById(R.id.card_quiz_button_quiz2);
//            me_q3 = (FloatingActionButton) me_quiz_layout.findViewById(R.id.card_quiz_button_quiz3);
            me_q1 = (Button) me_quiz_layout.findViewById(R.id.card_quiz_button_quiz1);
            me_q2 = (Button) me_quiz_layout.findViewById(R.id.card_quiz_button_quiz2);
            me_q3 = (Button) me_quiz_layout.findViewById(R.id.card_quiz_button_quiz3);
            //me_quiz = new FloatingActionButton[]{me_q1,me_q2, me_q3};
            me_quiz = new Button[]{me_q1,me_q2, me_q3};
            opponent_quiz_layout = (LinearLayout) opponent_card_quiz.findViewById(R.id.card_quiz_quiz_layout);
//            opponent_q1 = (FloatingActionButton) opponent_quiz_layout.findViewById(R.id.card_quiz_button_quiz1);
//            opponent_q2 = (FloatingActionButton) opponent_quiz_layout.findViewById(R.id.card_quiz_button_quiz2);
//            opponent_q3 = (FloatingActionButton) opponent_quiz_layout.findViewById(R.id.card_quiz_button_quiz3);
            opponent_q1 = (Button) opponent_quiz_layout.findViewById(R.id.card_quiz_button_quiz1);
            opponent_q2 = (Button) opponent_quiz_layout.findViewById(R.id.card_quiz_button_quiz2);
            opponent_q3 = (Button) opponent_quiz_layout.findViewById(R.id.card_quiz_button_quiz3);
//            opponent_quiz = new FloatingActionButton[]{opponent_q1, opponent_q2, opponent_q3};
            opponent_quiz = new Button[]{opponent_q1, opponent_q2, opponent_q3};
            me_button_game_layout = (LinearLayout) me_card_quiz.findViewById(R.id.card_quiz_button_game_layout);
            opponent_label_game_layout = (LinearLayout)opponent_card_quiz.findViewById(R.id.card_quiz_label_game_layout);
            btnGame = (Button) me_button_game_layout.findViewById(R.id.card_quiz_button_game);
            btnGame.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onGameButtonClick();
                }
            });
            me_q1.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int p=0;
                    if(round!=null&&round.questions.size()>p)
                        callback.onQuizClick(round.questions.get(p));
                }
            });
            me_q2.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int p=1;
                    if(round!=null&&round.questions.size()>p)
                        callback.onQuizClick(round.questions.get(p));
                }
            });
            me_q3.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int p=2;
                    if(round!=null&&round.questions.size()>p)
                        callback.onQuizClick(round.questions.get(p));
                }
            });
            opponent_q1.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int p=0;
                    if(round!=null&&round.questions.size()>p)
                        callback.onQuizClick(round.questions.get(p));
                }
            });
            opponent_q2.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int p=1;
                    if(round!=null&&round.questions.size()>p)
                        callback.onQuizClick(round.questions.get(p));
                }
            });
            opponent_q3.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int p=2;
                    if(round!=null&&round.questions.size()>p)
                        callback.onQuizClick(round.questions.get(p));
                }
            });
        }
    }
    public interface GameRoundCallback{
        public void onQuizClick(GameRoundQuestionModel quiz);
        public void onGameButtonClick();
    }
}
