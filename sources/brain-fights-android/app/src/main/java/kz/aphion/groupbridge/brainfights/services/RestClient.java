package kz.aphion.groupbridge.brainfights.services;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import kz.aphion.groupbridge.brainfights.utils.Const;
import retrofit.RestAdapter;
import retrofit.converter.GsonConverter;

/**
 * Created by alimjan on 04.11.2015.
 */
public class RestClient {
    private BrainFightsApi brainFightsApi;
    public RestClient(){
        Gson gson = new GsonBuilder().create();
        RestAdapter restAdapter = new RestAdapter.Builder()
                .setLogLevel(RestAdapter.LogLevel.FULL)
                .setEndpoint(Const.BASE_URL)
                .setConverter(new GsonConverter(gson))

                .build();
        brainFightsApi = restAdapter.create(BrainFightsApi.class);
    }
    public BrainFightsApi getBrainFightsApi() {
        return brainFightsApi;
    }
}
