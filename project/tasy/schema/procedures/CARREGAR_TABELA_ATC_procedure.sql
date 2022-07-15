-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carregar_tabela_atc ( cd_atc_p text, ds_atc_p text, qt_ddd_p text, cd_unidade_medida_p text, ie_via_administracao_p text, ds_observacao_p text, nm_usuario_p text, ie_opcao_p text) AS $body$
DECLARE


/* ie_opcao_p: I - Insert; U - Update */

BEGIN

if (ie_opcao_p = 'I') then
	insert into w_atc(
		nr_sequencia,
		cd_atc,
		ds_atc,
		qt_ddd,
		cd_unidade_medida,
		ie_via_administracao,
		ds_observacao)
	values (nextval('w_atc_seq'),
		substr(cd_atc_p,1,10),
		substr(ds_atc_p,1,255),
		(qt_ddd_p)::numeric ,
		substr(cd_unidade_medida_p,1,30),
		substr(ie_via_administracao_p,1,30),
		substr(ds_observacao_p,1,255));
elsif (ie_opcao_p = 'U') then
	update	w_atc
	set	ds_atc	= substr(ds_atc || ' ' || ds_atc_p,1,255)
	where	cd_atc	= cd_atc_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carregar_tabela_atc ( cd_atc_p text, ds_atc_p text, qt_ddd_p text, cd_unidade_medida_p text, ie_via_administracao_p text, ds_observacao_p text, nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

