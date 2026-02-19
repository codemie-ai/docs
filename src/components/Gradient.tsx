import { FC } from 'react';
import GradientLight from '@site/static/img/gradient.png';
import GradientDark from '@site/static/img/gradient-light.png';

const Gradient: FC = () => {
  return (
    <div
      className={
        'absolute bottom-0 left-0 pointer-events-none transition-all duration-150 select-none opacity-50'
      }
    >
      <img
        src={GradientLight}
        className="min-w-[450px] block lightTheme:hidden"
        alt="background-gradient"
      />
      <img
        src={GradientDark}
        className="min-w-[600px] block darkTheme:hidden"
        alt="background-gradient"
      />
    </div>
  );
};

export default Gradient;
