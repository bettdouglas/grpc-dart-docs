import React from 'react';
import clsx from 'clsx';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Speed up your applications 🔥',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        gRPC is roughly 7 times faster than REST when receiving data & roughly 10 times faster than REST when sending data
      </>
    ),
  },
  {
    title: 'Use Protocol Buffers',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
       <ol>
       Built on top of protobuf which offers 
        <li> Compact data storage meaning smaller network latency</li>
        <li>Fast parsing and availability in many languages. </li>
        <li>Optimized functionality through automatically-generated classes.</li>
       </ol>
    ),
  },
  {
    title: 'Use the full power of Dart',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        You've seen how powerful the dart lanugage is on Flutter. Bring the same power to your backends. 
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
