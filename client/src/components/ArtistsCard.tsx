import { FC, useState, useEffect } from 'react';
import { Artist } from 'lib/artist';
import ArtistListElementCard from 'components/ArtistListElementCard';
import Grid from '@mui/material/Grid';
import getLoginUserName from 'lib/getLoginUserName';
import { ApolloError, useQuery } from '@apollo/client';
import { User, UserByNameInput, getUserByNameQuery } from 'lib/user';
import toast from 'react-hot-toast';

type ArtistsCardProps = {
  artists: Artist[];
};

const ArtistsCard: FC<ArtistsCardProps> = ({ artists }) => {
  const [currentUserName, setCurrentUserName] = useState<string>('');
  const [currentUserArtists, setCurrentUserArtists] = useState<Set<Artist>>(
    new Set(),
  );
  const [loading, setLoading] = useState<boolean>(true);
  const { refetch } = useQuery<{ userByName: User }, UserByNameInput>(
    getUserByNameQuery,
    {
      variables: { name: currentUserName },
    },
  );

  useEffect(() => {
    setCurrentUserName(getLoginUserName());
  }, [setCurrentUserName]);

  useEffect(() => {
    if (currentUserName) {
      refetch()
        .then((res) => {
          setCurrentUserArtists(new Set(res.data.userByName.artists));
          setLoading(false);
        })
        .catch((e: ApolloError) => {
          toast.error(e.message);
        });
    }
  }, [refetch, currentUserName]);

  return (
    <Grid container sx={{ width: 1200 }}>
      {artists.map((artist) => (
        <ArtistListElementCard
          key={artist.id}
          artist={artist}
          currentUserArtists={currentUserArtists}
          loading={loading}
          currentUserName={currentUserName}
        />
      ))}
    </Grid>
  );
};

export default ArtistsCard;
