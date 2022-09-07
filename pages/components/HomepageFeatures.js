import clsx from "clsx"
import React from "react"
import styles from "./HomepageFeatures.module.css"

const FeatureList = [
  {
    title: "Easy to Use",
    description: (
      <>
        Each of the modules in dToolkit was made to be very easy to use by new and experienced developers alike!
      </>
    ),
  },
  {
    title: "No Setup",
    description: (
      <>
        Just plop dToolkit into your experience, and you're all set!
      </>
    ),
  },
  {
    title: "Typechecking Galore",
    description: (
      <>
        dToolkit has typechecking for all of its classes, and every library also implements typechecking to be as easy to
        implement into your projects!
      </>
    ),
  },
]

function Feature({ Png, title, description }) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">
        {Png && <Png className={styles.featurePng} alt={title} />}
      </div>
      <div className=" padding-horiz--md">
        <h3 className="text--center">{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  )
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
  )
}