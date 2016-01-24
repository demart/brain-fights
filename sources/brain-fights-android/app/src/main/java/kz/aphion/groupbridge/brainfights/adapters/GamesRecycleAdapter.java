package kz.aphion.groupbridge.brainfights.adapters;

import android.content.Context;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.github.siyamed.shapeimageview.CircularImageView;
import com.squareup.picasso.Picasso;

import org.w3c.dom.Text;

import java.text.ParseException;
import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.utils.Const;
import kz.aphion.groupbridge.brainfights.utils.Util;

/**
 * Created by alimjan on 08.11.2015.
 */
public class GamesRecycleAdapter extends RecyclerView.Adapter<GamesRecycleAdapter.ViewHolder> {
    private final Context context;
    List<GameModel> gamesList;
    GamesListType gamesType;
    GamesRecycleOnClickCallback callback;
    int layout;
    public GamesRecycleAdapter(int layout, List<GameModel> gamesList, GamesListType gamesType, GamesRecycleOnClickCallback callback, Context context){
        super();
        this.gamesList = gamesList;
        this.gamesType = gamesType;
        this.callback = callback;
        this.layout = layout;
        this.context = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        return new ViewHolder(v, callback, gamesType);
    }
    private String getScores(GameModel game){
        if(game.me.correctAnswerCount>game.oponent.correctAnswerCount){
            StringBuilder sb = new StringBuilder(game.me.correctAnswerCount.toString());
            sb.append(":");
            sb.append(game.oponent.correctAnswerCount.toString());
            sb.append(" в вашу пользу");
            return sb.toString();
        }else if(game.me.correctAnswerCount==game.oponent.correctAnswerCount){
            StringBuilder sb = new StringBuilder(game.me.correctAnswerCount.toString());
            sb.append(":");
            sb.append(game.oponent.correctAnswerCount.toString());
            sb.append(" равная борьба");
            return sb.toString();
        }else {
            StringBuilder sb = new StringBuilder(game.me.correctAnswerCount.toString());
            sb.append(":");
            sb.append(game.oponent.correctAnswerCount.toString());
            sb.append(" в пользу противника");
            return  sb.toString();
        }
    }
    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        GameModel game = gamesList.get(position);
        switch (gamesType){
            case ACTIVE:
                switch (game.me.status){
                    case WAITING_OWN_DECISION:
                        holder.status.setText("Вызов!");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.circled_right));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
//                        holder.waitingAction.setText("Вызов от "+game.oponent.user.getName());
//                        holder.scores.setVisibility(View.GONE);
                        break;
                    default:
                        holder.status.setText("Ваш ход!");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.circled_right));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
//                        holder.waitingAction.setText("Ваш ход против "+game.oponent.user.getName());
//                        holder.scores.setText(getScores(game));
                }
                try {
                    holder.waitingTime.setText(Util.getWaitingTime(game.me.lastUpdateStatusDate)); //TODO: Сделать расчет
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                holder.cardView.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_orange));
                break;
            case WAITING:
                switch (game.me.status){
                    case WAITING_OWN_DECISION:

                        break;
                    case WAITING_OPONENT_DECISION:
                        holder.status.setText("Ждем игрока");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.clock_filled));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                    case WAITING_OPONENT:
//                        holder.waitingAction.setText(game.oponent.user.getName() +" играет");
//                        holder.scores.setText(getScores(game));
//                        holder.scores.setVisibility(View.VISIBLE);
                        holder.status.setText("Ждем игрока");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.clock_filled));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                    case WAITING_ANSWERS:

                        break;
                    case WAITING_ROUND:

                        break;

                }
                //holder.waitingAction.setText(game.oponent.user.getName()+" играет");
                try {
                    holder.waitingTime.setText(Util.getWaitingTime(game.oponent.lastUpdateStatusDate)); //TODO: Сделать расчет
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                holder.cardView.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_green));
                break;
            case FINISHED:
                switch (game.me.status){
                    case WINNER:
                        holder.status.setText("Победа!");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.trophy_filled));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                    case DRAW:
                        holder.status.setText("Ничья");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.draw));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                    case LOOSER:
                        holder.status.setText("Проигрыш");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.loosing_filled));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                    case SURRENDED:
//                        holder.status.setText("Вы сдались");
                        holder.status.setText("Вы сдались");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.loosing_filled));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                    case OPONENT_SURRENDED:
//                        holder.status.setText("Противник сдался");
                        holder.status.setText("Противник сдался!");
                        holder.gameIcon.setImageDrawable(context.getResources().getDrawable(R.drawable.trophy_filled));
                        holder.opponentName.setText(game.oponent.user.getName());
                        holder.opponentPosition.setText(game.oponent.user.getPosition());
                        break;
                }
//                holder.opponent.setText("против: "+game.oponent.user.getName());
                holder.cardView.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_darkGary));
                holder.avatar.setAlpha((float) 0.5);
                break;
        }
        holder.gamePosition = position;
        if(game.oponent.user.imageUrl!=null&&game.oponent.user.imageUrl.length()>0)
            Picasso.with(context).load(Const.BASE_URL+game.oponent.user.imageUrl).into(holder.avatar);
    }

    @Override
    public int getItemCount() {
        return gamesList.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public  int gamePosition=-1;

        public TextView waitingTime;
//        public TextView scores;
//        public TextView waitingAction;
//        public TextView activeAction;
//        public TextView opponent;
        public TextView opponentName;
        public TextView opponentPosition;
        public TextView status;
        public CardView cardView;
        ImageView gameIcon;
        CircularImageView avatar;

        public ViewHolder(View itemView, final GamesRecycleOnClickCallback callback, final GamesListType gamesListType ) {
            super(itemView);
            cardView = (CardView)itemView.findViewById(R.id.game_card);
            cardView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    callback.onGameClickCallback(gamesListType, gamePosition);
                }
            });
//            waitingAction = (TextView) cardView.findViewById(R.id.game_card_wait_status);
//            scores = (TextView)cardView.findViewById(R.id.game_card_score);
            waitingTime = (TextView) cardView.findViewById(R.id.game_card_time_waiting);
            status = (TextView) cardView.findViewById(R.id.game_status);
            opponentName = (TextView) cardView.findViewById(R.id.gamer_name);
            opponentPosition = (TextView) cardView.findViewById(R.id.gamer_position);
            gameIcon = (ImageView) cardView.findViewById(R.id.game_icon);
            avatar = (CircularImageView) cardView.findViewById(R.id.user_profile_avatar);
//            activeAction = (TextView) cardView.findViewById(R.id.game_card_active_action);
//            opponent = (TextView) cardView.findViewById(R.id.game_card_opponent);
//            status = (TextView)cardView.findViewById(R.id.game_card_status);
            switch (gamesListType){
                case ACTIVE:
//                    waitingAction.setVisibility(View.VISIBLE);
//                    scores.setVisibility(View.VISIBLE);
                    waitingTime.setVisibility(View.VISIBLE);
//                    activeAction.setVisibility(View.GONE);
//                    opponent.setVisibility(View.GONE);
//                    status.setVisibility(View.GONE);
                    break;
                case WAITING:
//                    waitingAction.setVisibility(View.VISIBLE);
//                    scores.setVisibility(View.VISIBLE);
                    waitingTime.setVisibility(View.VISIBLE);
//                    activeAction.setVisibility(View.GONE);
//                    opponent.setVisibility(View.GONE);
//                    status.setVisibility(View.GONE);
                    break;
                case FINISHED:
//                    waitingAction.setVisibility(View.GONE);
//                    scores.setVisibility(View.GONE);
                    waitingTime.setVisibility(View.GONE);
//                    activeAction.setVisibility(View.GONE);
//                    opponent.setVisibility(View.VISIBLE);
//                    status.setVisibility(View.VISIBLE);
                    break;
            }
        }
    }
    public enum GamesListType{
        ACTIVE,
        WAITING,
        FINISHED
    }
    public interface GamesRecycleOnClickCallback{
        public void onGameClickCallback(GamesListType gamesListType, int gamePosition);
    }
}
