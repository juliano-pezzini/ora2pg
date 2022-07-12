-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE import_drug_master_jp_l10_pkg.insert_drug_master_version ( cd_estabelecimento_p text, nr_version_p text, nm_usuario_p text, ds_comment_p text, mims_version_p INOUT mims_version.nr_sequencia%type ) AS $body$
DECLARE

        mims_version_w       mims_version%rowtype;
        mims_version_seq_w   mims_version.nr_sequencia%type;

BEGIN
        select
            nextval('mims_version_seq')
        into STRICT mims_version_seq_w
;

        mims_version_w.nm_usuario := nm_usuario_p;
        mims_version_w.nm_usuario_nrec := nm_usuario_p;
        mims_version_w.dt_atualizacao := clock_timestamp();
        mims_version_w.dt_atualizacao_nrec := clock_timestamp();
        mims_version_w.dt_importation_material_cat := clock_timestamp();
        mims_version_w.nr_sequencia := mims_version_seq_w;
        mims_version_w.ie_status := '5';      --Pending
        mims_version_w.nr_version := nr_version_p;
        mims_version_w.ds_comments := ds_comment_p;
        insert into mims_version values (mims_version_w.*);

        commit;
        mims_version_p := mims_version_seq_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_drug_master_jp_l10_pkg.insert_drug_master_version ( cd_estabelecimento_p text, nr_version_p text, nm_usuario_p text, ds_comment_p text, mims_version_p INOUT mims_version.nr_sequencia%type ) FROM PUBLIC;