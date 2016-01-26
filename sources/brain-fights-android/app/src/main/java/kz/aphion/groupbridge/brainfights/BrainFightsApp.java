package kz.aphion.groupbridge.brainfights;

import android.app.Application;

import com.squareup.picasso.OkHttpDownloader;
import com.squareup.picasso.Picasso;

/**
 * Created by alimjan on 29.12.2015.
 */
public class BrainFightsApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
//        Picasso.Builder builder = new Picasso.Builder(this);
//        builder.downloader(new OkHttpDownloader(this,Integer.MAX_VALUE));
//        Picasso built = builder.build();
//        built.setIndicatorsEnabled(true);
////        built.setLoggingEnabled(true);
//        Picasso.setSingletonInstance(built);

    }
}
