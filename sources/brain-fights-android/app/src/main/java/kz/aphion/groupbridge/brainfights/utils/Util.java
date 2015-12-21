package kz.aphion.groupbridge.brainfights.utils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.widget.LinearLayout;

import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.EnumSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

/**
 * Created by alimjan on 04.11.2015.
 */
public class Util {
    static SimpleDateFormat dateFormat=null;
    private static SimpleDateFormat getDateFormat(){
        if(dateFormat==null){
            dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        }
        return dateFormat;
    }
    public static String getAppVersion(Context context){
        PackageManager manager = context.getPackageManager();
        PackageInfo info = null;
        try {
            info = manager.getPackageInfo(context.getPackageName(), 0);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return "Unknown";
        }
        return info.versionName;
    }
    public static String getWaitingTime(String date) throws ParseException {
        return getWaitingTime(getDateFromString(date));
    }
    public static String getWaitingTime(Date startDate){
        Map<TimeUnit, Long> diff = computeDiff(startDate, new Date());
        if(diff.get(TimeUnit.DAYS)>0){
            return diff.get(TimeUnit.DAYS)+"д.";
        }else if(diff.get(TimeUnit.HOURS)>0) {
            return diff.get(TimeUnit.HOURS) + "ч.";
        }else if(diff.get(TimeUnit.MINUTES)>0){
            return diff.get(TimeUnit.MINUTES) + "мин.";
        }else return "0 мин.";
    }
    public static Map<TimeUnit,Long> computeDiff(Date date1, Date date2) {
        long diffInMillies = date2.getTime() - date1.getTime();
        List<TimeUnit> units = new ArrayList<TimeUnit>(EnumSet.allOf(TimeUnit.class));
        Collections.reverse(units);
        Map<TimeUnit,Long> result = new LinkedHashMap<TimeUnit,Long>();
        long milliesRest = diffInMillies;
        for ( TimeUnit unit : units ) {
            long diff = unit.convert(milliesRest,TimeUnit.MILLISECONDS);
            long diffInMilliesForUnit = unit.toMillis(diff);
            milliesRest = milliesRest - diffInMilliesForUnit;
            result.put(unit,diff);
        }
        return result;
    }
    public static Date getDateFromString(String date) throws ParseException {
        return getDateFormat().parse(date);
    }
    public static Target getTargetLayoutBg(final LinearLayout layout){
        return new Target() {
            @Override
            public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
                layout.setBackgroundDrawable(new BitmapDrawable(bitmap));
            }

            @Override
            public void onBitmapFailed(Drawable errorDrawable) {

            }

            @Override
            public void onPrepareLoad(Drawable placeHolderDrawable) {

            }
        };
    }
}
