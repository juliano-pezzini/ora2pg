-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_hem_acesso (nr_seq_proc_p bigint, nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE


ie_acesso_w			    hem_acesso.ie_acesso%type;
ie_tipo_acesso_w        hem_acesso.ie_tipo_acesso%type;
ie_vaso_acesso_w        hem_acesso.ie_vaso_acesso%type;
ie_lat_acesso_w         hem_acesso.ie_lat_acesso%type;
nr_introdutor_w         hem_acesso.nr_introdutor%type;
nr_seq_cirurgia_w       hem_acesso.nr_seq_cirurgia%type;
nr_seq_oclusor_w        hem_acesso.nr_seq_oclusor%type;
qt_oclusor_w            hem_acesso.qt_oclusor%type;


BEGIN

if (coalesce(nr_seq_proc_p,0) > 0) then
	SELECT Obter_Regra_Atributo(cd_estabelecimento_p,
                                obter_perfil_ativo, nm_usuario_p,
                                'HEM_ACESSO',
                                'IE_ACESSO',
                                'V',
                                0,
                                0,
                                0,
                                0,
                                NULL,
                                NULL) into STRICT ie_acesso_w
;

    SELECT Obter_Regra_Atributo(cd_estabelecimento_p,
                                obter_perfil_ativo, nm_usuario_p,
                                'HEM_ACESSO',
                                'IE_TIPO_ACESSO',
                                'V',
                                0,
                                0,
                                0,
                                0,
                                NULL,
                                NULL) into STRICT ie_tipo_acesso_w
;

    SELECT  Obter_Regra_Atributo(cd_estabelecimento_p,
                                 obter_perfil_ativo,
                                 nm_usuario_p,
                                 'HEM_ACESSO',
                                 'IE_VASO_ACESSO',
                                 'V',
                                 0,
                                 0,
                                 0,
                                 0,
                                 NULL,
                                 NULL) into STRICT ie_vaso_acesso_w
;

    SELECT  Obter_Regra_Atributo(cd_estabelecimento_p,
                                 obter_perfil_ativo,
                                 nm_usuario_p,
                                 'HEM_ACESSO',
                                 'IE_LAT_ACESSO',
                                 'V',
                                 0,
                                 0,
                                 0,
                                 0,
                                 NULL,
                                 NULL) into STRICT ie_lat_acesso_w
;

    SELECT  Obter_Regra_Atributo(cd_estabelecimento_p,
                                 obter_perfil_ativo,
                                 nm_usuario_p,
                                 'HEM_ACESSO',
                                 'NR_INTRODUTOR',
                                 'V',
                                 0,
                                 0,
                                 0,
                                 0,
                                 NULL,
                                 NULL) into STRICT nr_introdutor_w
;

    SELECT  Obter_Regra_Atributo(cd_estabelecimento_p,
                                 obter_perfil_ativo,
                                 nm_usuario_p,
                                 'HEM_ACESSO',
                                 'NR_SEQ_OCLUSOR',
                                 'V',
                                 0,
                                 0,
                                 0,
                                 0,
                                 NULL,
                                 NULL) into STRICT nr_seq_oclusor_w
;

    SELECT  Obter_Regra_Atributo(cd_estabelecimento_p,
                                 obter_perfil_ativo,
                                 nm_usuario_p,
                                 'HEM_ACESSO',
                                 'QT_OCLUSOR',
                                 'V',
                                 0,
                                 0,
                                 0,
                                 0,
                                 NULL,
                                 NULL) into STRICT qt_oclusor_w
;

    SELECT  nr_seq_cirurgia into STRICT nr_seq_cirurgia_w
    FROM    hem_proc
    where   nr_procedimento = nr_seq_proc_p;

    if ((ie_vaso_acesso_w IS NOT NULL AND ie_vaso_acesso_w::text <> '') and (ie_acesso_w IS NOT NULL AND ie_acesso_w::text <> '') and (nr_introdutor_w IS NOT NULL AND nr_introdutor_w::text <> '')) then
	    insert into hem_acesso(
                    nr_sequencia,
                    dt_atualizacao,
                    nm_usuario ,
                    dt_atualizacao_nrec,
                    nm_usuario_nrec,
                    nr_seq_proc,
                    ie_vaso_acesso,
                    ie_acesso,
                    ie_lat_acesso,
                    ie_tipo_acesso,
                    nr_introdutor,
                    nr_seq_cirurgia,
			        nr_seq_oclusor,
			        qt_oclusor
		           ) values (   nextval('hem_acesso_seq'),
                         clock_timestamp(),
                         nm_usuario_p,
                         clock_timestamp(),
                         nm_usuario_p,
                         nr_seq_proc_p,
                         ie_vaso_acesso_w,
                         ie_acesso_w,
                         ie_lat_acesso_w,
                         ie_tipo_acesso_w,
                         nr_introdutor_w,
                         nr_seq_cirurgia_w,
                         nr_seq_oclusor_w,
                         qt_oclusor_w
                    );
    end if;
end if;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_hem_acesso (nr_seq_proc_p bigint, nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;
