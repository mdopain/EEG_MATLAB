function [ Xmin, Ymin, Xmax, Ymax ] = getMinMax( EEG, t0 )

    Ymin = min( EEG( (t0 + 50):(t0 + 350)) );
    Ymax = max( EEG( (t0 + 100):(t0 + 500)) );

    Xmin = ( find( EEG == Ymin ) - t0 );
    Xmax = ( find( EEG == Ymax ) - t0 );
end