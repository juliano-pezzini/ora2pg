-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_copiar_versoes_build ( nr_sequencia_ctrl_build_p bigint, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	man_os_ctrl_build a
	where	nr_sequencia != nr_sequencia_ctrl_build_p
	and 	nr_seq_man_os_ctrl_desc = (SELECT max(nr_seq_man_os_ctrl_desc) from man_os_ctrl_build b where b.nr_sequencia  = nr_sequencia_ctrl_build_p)
	and		not exists (select 1 from man_os_ctrl_build_alt c where a.nr_sequencia = c.nr_seq_man_os_ctrl_build);

C02 CURSOR FOR
	SELECT	nr_sequencia,
		ds_projeto,
		ds_classe,
		cd_pessoa_fisica,
		cd_ramal,
		ie_localizacao,
		substr(ds_alteracao, 1, 1999) ds_alteracao,
		ie_camada
 	from	man_os_ctrl_build_alt
	where	nr_seq_man_os_ctrl_build = nr_sequencia_ctrl_build_p;
BEGIN

FOR rs_C01 IN C01 LOOP
	FOR rs_C02 IN C02 LOOP
		insert into man_os_ctrl_build_alt( 	nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										ds_projeto,
										ds_classe,
										cd_pessoa_fisica,
										cd_ramal,
										ie_localizacao,
										ds_alteracao,
										ie_camada,
										nr_seq_man_os_ctrl_build
										)
									values (
										nextval('man_os_ctrl_build_alt_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										rs_C02.ds_projeto,
										rs_C02.ds_classe,
										rs_C02.cd_pessoa_fisica,
										rs_C02.cd_ramal,
										rs_C02.ie_localizacao,
										rs_C02.ds_alteracao,
										rs_C02.ie_camada,
										rs_C01.nr_sequencia);
	END LOOP;
END LOOP;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_copiar_versoes_build ( nr_sequencia_ctrl_build_p bigint, nm_usuario_p text) FROM PUBLIC;
