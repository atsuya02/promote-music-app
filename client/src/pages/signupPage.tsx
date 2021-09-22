import { FC, useState, useEffect } from 'react';
import { useMutation } from '@apollo/client';
import { createUserMutation, UserData } from 'lib/user';
import { useNavigate } from 'react-router';

const SignupPage: FC = () => {
  const navigate = useNavigate();
  const [createUser, { loading, error }] =
    useMutation<{ createUser: UserData }>(createUserMutation);
  const [value, setValue] = useState<string>('');

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setValue(event.target.value);
  };

  useEffect(() => {
    const userName = localStorage.getItem('loginUser');
    if (userName) {
      navigate('/');
    }
  });

  /* eslint no-console: ["error", { allow: ["error"] }] */
  const handleClick = () => {
    createUser({ variables: { name: value } })
      .then((res) => {
        localStorage.setItem(
          'loginUser',
          res.data?.createUser.user.name as string,
        );
        navigate('/');
      })
      .catch((e) => {
        console.error(e);
      });
  };

  if (loading) return <>Submitting</>;
  if (error) return <>Error: {error.message}</>;

  return (
    <>
      <input onChange={handleChange} value={value} type="text" />
      <button type="submit" onClick={handleClick}>
        登録
      </button>
    </>
  );
};

export default SignupPage;