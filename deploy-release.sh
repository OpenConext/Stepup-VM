#!/bin/bash

# Deploy all components of a release form tarballs published on github.
# Use "--help" for help and more options

# Default release to deploy
RELEASE=SAT

# Self asserted tokens (SAT) release (WIP)
COMPONENTS_RELEASE_SAT=(
"Stepup-Gateway-4.0.3-20230412072113Z-4949594444180dea2d422135dd19f30dfbd0abde.tar.bz2" # new
"Stepup-Middleware-5.0.10-20230418061843Z-5eb3493bc16649c2ce48d54f6d13f63ff494f1ac.tar.bz2" # new
"Stepup-SelfService-4.0.6-20230504122946Z-3b305daf1794c5cd43ce9dd778eeef4925d16da2.tar.bz2" # new
"Stepup-RA-5.0.5-20230424114754Z-ec1e65741d44681d5aa7f59b12c62254e38d686a.tar.bz2" # new
"Stepup-tiqr-3.4.5-20221020125913Z-c79fd6ef0cbfb1c08d1b3d2ab01ad58e2638ec9f.tar.bz2"
#"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
"Stepup-Azure-MFA-1.4.5-20220208160607Z-913f30b3ab1378989e24e6d1ca1e98c6ca758662.tar.bz2"
"Stepup-Webauthn-1.0.14-20220210102123Z-2c50cd1b2329eb366251e9c01dde89126b1a93b6.tar.bz2"
)

COMPONENTS_RELEASE_31=(
"Stepup-Gateway-4.0.2-20230214110111Z-004197ab8cf44bdb6be19ff13b8a88e7c73ac2c3.tar.bz2" # new
"Stepup-Middleware-4.5.2-20221115134340Z-17990a991d535801fe6a72a3fb7835706a8af65f.tar.bz2" # new
"Stepup-SelfService-3.5.5-20220510084411Z-a96ef9246fb9b4d84e56c5174fb9ea271198a0d3.tar.bz2" # new
"Stepup-RA-4.3.6-20220323084943Z-5d8e7f18295dd0444a9c1a6ffca752d20c10b597.tar.bz2" # new
"Stepup-tiqr-3.4.5-20221020125913Z-c79fd6ef0cbfb1c08d1b3d2ab01ad58e2638ec9f.tar.bz2" # new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
"Stepup-Azure-MFA-1.4.5-20220208160607Z-913f30b3ab1378989e24e6d1ca1e98c6ca758662.tar.bz2"
"Stepup-Webauthn-1.0.14-20220210102123Z-2c50cd1b2329eb366251e9c01dde89126b1a93b6.tar.bz2"
)

#30
#"Stepup-tiqr-3.4.4-20220906113758Z-d58522458ec85ca6d48c6cf5c7544403973f8af7.tar.bz2" # new

#29
#"Stepup-Gateway-3.4.7-20220608062136Z-566a2ce23d53095c93f30c16d53157bfa917ee90.tar.bz2" # new

#28
#"Stepup-Middleware-4.5.2-20221115134340Z-17990a991d535801fe6a72a3fb7835706a8af65f.tar.bz2"  # new
#"Stepup-Middleware-4.5.0-20220407092853Z-20e0f0224d3334b0b972a5d07becbb63198c6a15.tar.bz2" # new
#"Stepup-Azure-MFA-1.4.5-20220208160607Z-913f30b3ab1378989e24e6d1ca1e98c6ca758662.tar.bz2" # new
#"Stepup-Gateway-3.4.6-20220420130232Z-84df54f5b256f60821147bad9b866840c705be2e.tar.bz2" # new
#"Stepup-tiqr-3.1.4-20220419143033Z-fef3e683ae774d5540cd7806ce0719bc649b657e.tar.bz2" # new

#27
#"Stepup-Gateway-3.4.5-20220223103329Z-396bc893b85fbeb345fa62a6183c5e20530516bc.tar.bz2" # new
#"Stepup-Middleware-4.4.1-20220208153826Z-f59282c21834eb8eef153cf3b04b3c7a5e353ec5.tar.bz2" # new


COMPONENTS_RELEASE_18=(
"Stepup-Gateway-3.0.1-20200415094937Z-ba031888bdbfee9517eded9553c1bb73a20229a0.tar.bz2"
"Stepup-Middleware-3.1.8-20200519144844Z-ab193b0c596f8ac426d3222aa87d4764e1600644.tar.bz2"
"Stepup-SelfService-3.1.0-20200123094957Z-899924d0139418958a9e502aa52eeea34494053d.tar.bz2"
"Stepup-RA-3.1.3-20200316151150Z-3adf37d912d2c42ffab98b4a81abdbae9d37480f.tar.bz2"
"Stepup-tiqr-2.1.15-20191107142732Z-92072c0ec958a9725dff1658ecd0279d224c84ed.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
"Stepup-Azure-MFA-1.2.1-20200917120714Z-918bb78d0ba6e3349f5749d0b1c6309923036d22.tar.bz2" # new
"Stepup-Webauthn-1.0.3-20200918145732Z-5c2a706365e405a2d3b75e4af41c53e828efc07f.tar.bz2" # new
)

COMPONENTS_RELEASE_17=(
"Stepup-Gateway-3.0.1-20200415094937Z-ba031888bdbfee9517eded9553c1bb73a20229a0.tar.bz2" # new
"Stepup-Middleware-3.1.8-20200519144844Z-ab193b0c596f8ac426d3222aa87d4764e1600644.tar.bz2" # new
"Stepup-SelfService-3.1.0-20200123094957Z-899924d0139418958a9e502aa52eeea34494053d.tar.bz2" # new
"Stepup-RA-3.1.3-20200316151150Z-3adf37d912d2c42ffab98b4a81abdbae9d37480f.tar.bz2" # new
"Stepup-tiqr-2.1.15-20191107142732Z-92072c0ec958a9725dff1658ecd0279d224c84ed.tar.bz2" # new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_16=(
"Stepup-Gateway-2.10.3-20190115133351Z-9ed43a8100c27c29a0ec25f28a5d7fa3b92d3d83.tar.bz2" # new
"Stepup-Middleware-2.9.3-20190115135113Z-31edf17a2d3dcf7f5df54f385926fcb5833c76c1.tar.bz2" # new
"Stepup-SelfService-2.10.6-20190225144626Z-945e18d66d3763752faae3dbec06874630224509.tar.bz2" # new
"Stepup-RA-2.10.6-20190130134255Z-a699dcde387161e491db75999461132ad474347b.tar.bz2" # new
"Stepup-tiqr-2.1.12-20190404120230Z-99d1bd2a8a9e914d661f71f321f3b3918f4465c6.tar.bz2" # new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_15=(
"Stepup-Gateway-2.9.1-20180620090223Z-19f8d51441f773bb9b21424f336f4b92b5509f46.tar.bz2" # new
"Stepup-Middleware-2.8.2-20180621075412Z-df63e3b315243349dbbda1624590f3779f7e9b73.tar.bz2" # new
"Stepup-SelfService-2.9.1-20180620090547Z-bac7b381514c98c334f00ce6d87c5db66f7a245c.tar.bz2" # new
"Stepup-RA-2.9.0-20180419113138Z-dc14e3b78b5aaf884db632e2f7d943a071e38a3f.tar.bz2" # new
"Stepup-tiqr-2.0.1-20180620092259Z-d2aaf27437cdf815b7fdd6ff822425b000f14934.tar.bz2" #new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_14=(
"Stepup-Gateway-2.8.3-20180404095536Z-c71690729b38ef4a570ea4c0a2cbd8e8b6fcbca5.tar.bz2" # new
"Stepup-Middleware-2.7.1-20180330083152Z-a3c457f93751ce97f6915326106515763b267594.tar.bz2" # new
"Stepup-SelfService-2.8.0-20180315090529Z-1ea292cf3ff8afc7e2edd1452c409b9d6de30ee8.tar.bz2" # new
"Stepup-RA-2.8.1-20180323142543Z-92c7a9bb3cf74524398a7d5ae7b8d69eecae7406.tar.bz2" # new
"Stepup-tiqr-1.1.8-20180306084707Z-acd4c5db5b22ff5fad48c032e0236fa27d1ae1ce.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_13_2=(
"Stepup-Gateway-2.7.5-20180306083743Z-0e0a9363987d1bcf72f1ca115bfe2530d9530b93.tar.bz2" # new
"Stepup-Middleware-2.6.4-20171215143000Z-64908ab6d4c3f574eff84243c2cda5ec0740634a.tar.bz2"
"Stepup-SelfService-2.7.2-20180306082744Z-990ac1dc6dc5b1a527a7890d06f6761500626e31.tar.bz2" # new
"Stepup-RA-2.7.3-20180306081925Z-7e16192cba2c45a297eae7d70f8f69d307320486.tar.bz2" # new
"Stepup-tiqr-1.1.8-20180306084707Z-acd4c5db5b22ff5fad48c032e0236fa27d1ae1ce.tar.bz2" # new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_13_1=(
"Stepup-Gateway-2.7.3-20180202094658Z-4fef3f641706a00449219bc3a8c60636126e7c03.tar.bz2" # new
"Stepup-Middleware-2.6.4-20171215143000Z-64908ab6d4c3f574eff84243c2cda5ec0740634a.tar.bz2"
"Stepup-SelfService-2.7.0-20170801141012Z-d06bbb5ee3807dbd8e51338855e201ce41023c50.tar.bz2"
"Stepup-RA-2.7.1-20171215144931Z-6638a96573b7568256cf8e220f316260101c9443.tar.bz2"
"Stepup-tiqr-v1.1.5-20170424220742Z-d0aab72dcb5f0e37f49332039b27e6200bbe8318.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_13=(
"Stepup-Gateway-2.7.2-20180126151123Z-d6160b256779d94572322b2f06cffabd2ac70f2b.tar.bz2" # new
"Stepup-Middleware-2.6.4-20171215143000Z-64908ab6d4c3f574eff84243c2cda5ec0740634a.tar.bz2" # new
"Stepup-SelfService-2.7.0-20170801141012Z-d06bbb5ee3807dbd8e51338855e201ce41023c50.tar.bz2"
"Stepup-RA-2.7.1-20171215144931Z-6638a96573b7568256cf8e220f316260101c9443.tar.bz2" # new
"Stepup-tiqr-v1.1.5-20170424220742Z-d0aab72dcb5f0e37f49332039b27e6200bbe8318.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_12=(
"Stepup-Gateway-2.7.0-20171005084621Z-9445c4219f3dd9b1e901a5882943da273cd02db0.tar.bz2" # new
"Stepup-Middleware-2.6.0-20170801073238Z-15d255e9c64bdaf8fcce2f1806e9c4ab893ee24c.tar.bz2"
"Stepup-SelfService-2.7.0-20170801141012Z-d06bbb5ee3807dbd8e51338855e201ce41023c50.tar.bz2"
"Stepup-RA-2.7.0-20170801141958Z-1ba3e4d8b9d9df97d904842854da41c0ce498cb4.tar.bz2"
"Stepup-tiqr-v1.1.5-20170424220742Z-d0aab72dcb5f0e37f49332039b27e6200bbe8318.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_11=(
"Stepup-Gateway-2.6.0-20170801071509Z-57618638b03838a5ed21f7b5376342a1797030d7.tar.bz2" # new
"Stepup-Middleware-2.6.0-20170801073238Z-15d255e9c64bdaf8fcce2f1806e9c4ab893ee24c.tar.bz2" # new
"Stepup-SelfService-2.7.0-20170801141012Z-d06bbb5ee3807dbd8e51338855e201ce41023c50.tar.bz2" # new
"Stepup-RA-2.7.0-20170801141958Z-1ba3e4d8b9d9df97d904842854da41c0ce498cb4.tar.bz2" # new
"Stepup-tiqr-v1.1.5-20170424220742Z-d0aab72dcb5f0e37f49332039b27e6200bbe8318.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_10=(
"Stepup-Gateway-2.5.0-20170310090101Z-525d8b4a37d40dd1541aa9aa22f81b2535715426.tar.bz2" # new
"Stepup-Middleware-2.5.0-20170310104904Z-1c564128270dff2eeb4a1565afc983a027d9a787.tar.bz2" # new
"Stepup-SelfService-2.6.2-20170517121255Z-e4031c52eee042ad52085dbb8c0300a2eca400a2.tar.bz2" # new
"Stepup-RA-2.6.1-20170327113418Z-43c0eeccfd5fc91cfe31fb3c9b71ceb0789f2201.tar.bz2" # new
"Stepup-tiqr-v1.1.5-20170424220742Z-d0aab72dcb5f0e37f49332039b27e6200bbe8318.tar.bz2" # new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_9=(
"Stepup-Gateway-2.4.2-20170227124204Z-8f91163df68e1fc53665a23d0aad23db5c4f165d.tar.bz2" # new
"Stepup-Middleware-2.4.0-20170221153150Z-2d4a416e4a3c9832a9914f8d8aaf12a3c54d83ef.tar.bz2" # new
"Stepup-SelfService-2.5.0-20170221154613Z-fe5c1ff607652f47b6c297bc3c8622a787135846.tar.bz2" # new
"Stepup-RA-2.4.0-20161130155145Z-bafb84b3ee966990f5b2115d56b04988e7f0cc6b.tar.bz2"
"Stepup-tiqr-1.1.2-20160411073201Z-4e2581d65b4c589031df524b30627474eca9fa50.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_8=(
"Stepup-Gateway-2.1.0-20160808153413Z-99293417f90edc05415e7fa7b2873f563de7a8cd.tar.bz2"
"Stepup-Middleware-2.3.1-20161202111856Z-842810702ab76ce36b9fef8c00ba56f91f4bd935.tar.bz2" # new
"Stepup-SelfService-2.3.0-20161118105735Z-eebc000542020fa8518edf016221e9b973874bd2.tar.bz2" # new
"Stepup-RA-2.4.0-20161130155145Z-bafb84b3ee966990f5b2115d56b04988e7f0cc6b.tar.bz2" # new
"Stepup-tiqr-1.1.2-20160411073201Z-4e2581d65b4c589031df524b30627474eca9fa50.tar.bz2"
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

COMPONENTS_RELEASE_7=(
"Stepup-Gateway-2.1.0-20160808153413Z-99293417f90edc05415e7fa7b2873f563de7a8cd.tar.bz2" # new
"Stepup-Middleware-2.0.2-20160810101855Z-d8d88d778ea30379b606cbca58d9634ff0541b42.tar.bz2" # new
"Stepup-SelfService-2.1.0-20160812150713Z-0fe329a64b14e0f15cb956cd0c043e4b1595d8d7.tar.bz2" # new
"Stepup-RA-2.1.2-20160815123919Z-8939c8b11b1de79c3018ce7c7b4fe9d2ac62462b.tar.bz2" # new
"Stepup-tiqr-1.1.2-20160411073201Z-4e2581d65b4c589031df524b30627474eca9fa50.tar.bz2" # new
"oath-service-php-1.0.1-20150723081351Z-56c990e62b4ba64ac755ca99093c9e8fce3e8fe9.tar.bz2"
)

SINGLE_COMPONENT=""
vm_type=""

while [[ $# > 0 ]]
do
option="$1"
shift
    case $option in
        -h|--help)
        echo "Usage: $0 --docker|--vagrant [--release <release number>] [--component <component name>]"
        echo "Deploys all the components of the specified release. Components are downloaded from github when required."
        echo "By default all components from 'Release ${RELEASE}' are deployed."
        echo ""
        echo "--release <number> : Deploy the specified release"
        echo "--component <name> : Deploy only the specifed component"
        echo ""
        exit 0
        ;;
        -d|--docker)
        vm_type="docker"
        ;;
        -v|--varant)
        vm_type="vagrant"
        ;;
        -r|--release)
        RELEASE="$1"
        if [ -z "$1" ]; then
            error_exit "--release option requires argument"
        fi
        shift
        ;;
        -c|--component)
        SINGLE_COMPONENT="$1"
        if [ -z "$1" ]; then
            error_exit "--component option requires argument"
        fi
        shift
        ;;
        *)
        echo "Unknown option: '${option}'"
        exit 1
        ;;
    esac
done

if [ -z "$vm_type" ]; then
    echo "Usage: $0 --docker|--vagrant [--release <release number>] [--component <component name>]"
    echo "Error: Please specify --docker or --vagrant"
    exit 1
fi

#COMPONENTS=( "${COMPONENTS_RELEASE_7[@]}" )

eval COMPONENTS=( "\${COMPONENTS_RELEASE_${RELEASE}[@]}" )
if [ -z "$COMPONENTS" ]; then
    echo "Release ${RELEASE} is not defined"
    exit 1
fi

echo "Deploying component(s) of Release ${RELEASE}"

if [ ! -d "./tarballs" ]; then
    echo "Creating directory './tarballs' because is does not exist"
    mkdir "./tarballs"
fi

for comp in "${COMPONENTS[@]}"; do
    pattern='^(Stepup-Gateway|Stepup-Middleware|Stepup-SelfService|Stepup-RA|Stepup-tiqr|oath-service-php|Stepup-Azure-MFA|Stepup-Webauthn)-(.*)\.tar\.bz2$'
    [[ $comp =~ $pattern ]]
    repo_name=${BASH_REMATCH[1]}
    release_name=${BASH_REMATCH[2]}
    if [ ! -z "${SINGLE_COMPONENT}" -a "${repo_name}" != "${SINGLE_COMPONENT}" ]; then
        continue
    fi

    # a $release_name looks like this:
    #5.0.5-20221128154850Z-d03c0738b61a482de6e2d67ed2e98a098c35aa1d
    # Cut the last 57 characters from the release name to get the version number tag in release_tag
    # The github action uses only the versiontag, wheras the old Stepup-Build upload 
    # release script uses the release name. So we try both when downloading
    release_tag=$(echo "${release_name}" | rev | cut -c 58- | rev)
    if [ ! -f "./tarballs/$comp" ]; then
        echo "File './tarballs/${comp}' not found"
        if [ "${repo_name}" == "oath-service-php" ]; then
            download_url=https://github.com/SURFnet/${repo_name}/releases/download/${release_name}/${comp}
        else
            download_url=https://github.com/OpenConext/${repo_name}/releases/download/${release_name}/${comp}
        fi
        echo "Downloading ${download_url}"
        # -L: follow redirects
        # -f: fail on http errors
        # -o: output file
        curl -L -f -o "./tarballs/${comp}" "${download_url}"
        if [ $? -ne 0 ]; then
            echo "Download failed, trying alternative name"
            if [ "${repo_name}" == "oath-service-php" ]; then
                download_url=https://github.com/SURFnet/${repo_name}/releases/download/${release_tag}/${comp}
            else
                download_url=https://github.com/OpenConext/${repo_name}/releases/download/${release_tag}/${comp}
            fi
            echo "Downloading ${download_url}"
            curl -L -f -o "./tarballs/${comp}" "${download_url}"
            if [ $? -ne 0 ]; then
                echo "Download failed"
                exit 1
            fi
        fi
    fi
    echo "Deploying './tarballs/${comp}'"
    if [ "$vm_type" == "docker" ]; then
        echo docker exec -it stepupvm bash -c "/deploy/scripts/deploy.sh /tarballs/${comp} -i /environment/inventory.docker --vault-password-file /environment/stepup-ansible-vault-password "$@" -l 'app*'"
        docker exec -it stepupvm bash -c "/deploy/scripts/deploy.sh /tarballs/${comp} -i /environment/inventory.docker --vault-password-file /environment/stepup-ansible-vault-password "$@" -l 'app*'"
        res=$?
    fi
    if [ "$vm_type" == "vagrant" ]; then
        echo ./deploy/scripts/deploy.sh ./tarballs/${comp} -i ./environment/inventory -l 'app*'
        ./deploy/scripts/deploy.sh ./tarballs/${comp} -i ./environment/inventory -l 'app*'
        res=$?
    fi
    if [ $res -ne 0 ]; then
        echo "Deploy failed"
        exit 1
    fi
done

echo ""
echo "==========================================================="
echo "To run the bootstrap scripts on the application server use:"
echo "./bootstrap-app.sh --$vm_type"
echo "==========================================================="
