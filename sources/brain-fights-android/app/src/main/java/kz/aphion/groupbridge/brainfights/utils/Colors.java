package kz.aphion.groupbridge.brainfights.utils;

import android.content.Context;
import android.content.res.ColorStateList;

import kz.aphion.groupbridge.brainfights.R;

/**
 * Created by alimjan on 18.11.2015.
 */
public class Colors {
    public static void initGameColors(Context context){
        correctAnswerColors = context.getResources().getColorStateList(R.color.ttk_green);
//                new ColorStateList(
//                new int[][]{
//                        new int[]{android.R.attr.state_pressed}, //1
//                        new int[]{android.R.attr.state_focused}, //2
//                        new int[]{android.R.attr.state_focused, android.R.attr.state_pressed} //3
//                },
//                new int[] {
//                        context.getResources().getColor(R.color.ttk_green), //1
//                        context.getResources().getColor(R.color.ttk_green), //2
//                        context.getResources().getColor(R.color.ttk_orange) //3
//                }
//
//        );
        incorrectAnswerColors = context.getResources().getColorStateList(R.color.ttk_red);
//                new ColorStateList(
//                new int[][]{
//                        new int[]{android.R.attr.state_pressed}, //1
//                        new int[]{android.R.attr.state_focused}, //2
//                        new int[]{android.R.attr.state_focused, android.R.attr.state_pressed} //3
//                },
//                new int[] {
//                        context.getResources().getColor(R.color.ttk_red), //1
//                        context.getResources().getColor(R.color.ttk_red), //2
//                        context.getResources().getColor(R.color.ttk_orange) //3
//                }
//        );
        noAnswerColors =  context.getResources().getColorStateList(R.color.ttk_lightGray);
//                new ColorStateList(
//                new int[][]{
//                        new int[]{android.R.attr.state_pressed}, //1
//                        new int[]{android.R.attr.state_focused}, //2
//                        new int[]{android.R.attr.state_focused, android.R.attr.state_pressed} //3
//                },
//                new int[] {
//                        context.getResources().getColor(R.color.ttk_lightGray), //1
//                        context.getResources().getColor(R.color.ttk_lightGray), //2
//                        context.getResources().getColor(R.color.ttk_orange) //3
//                }
//        );
    }
    public static  ColorStateList correctAnswerColors;
    public static  ColorStateList incorrectAnswerColors;
    public static  ColorStateList noAnswerColors;
}
