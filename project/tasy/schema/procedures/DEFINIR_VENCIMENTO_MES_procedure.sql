-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_vencimento_mes ( ie_terc_liberados_p text, nr_sequencia_p text, ie_somente_selecionada_p text, dt_venc_p timestamp, dt_ref_p timestamp, ie_sobrepor_p text, nm_usuario_p text) AS $body$
DECLARE



ds_sql_where_w		varchar(4000);
ds_comando_w		varchar(4000);
ie_somente_terc_lib_w	varchar(1);
dt_venc_w		varchar(10);
dt_ref_w		varchar(10);



BEGIN

ie_somente_terc_lib_w := Obter_Param_Usuario(907, 53, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_somente_terc_lib_w);

dt_venc_w := substr(to_char(dt_venc_p,'dd/mm/RRRR'),1,10);
dt_ref_w  := substr(to_char(dt_ref_p,'dd/mm/RRRR'),1,10);

ds_comando_w	:=  ' update	terceiro_conta ' ||
		    ' set	dt_vencimento	= to_date('|| chr(39) || dt_venc_w || chr(39) ||', ''dd/mm/yyyy'') ' ||
		    ' where	to_char(dt_mesano_referencia, ''mm/RRRR'') = to_char(to_date('|| chr(39) || dt_ref_w || chr(39) ||' , ''dd/mm/RRRR''), ''mm/RRRR'') '||
		    ' and 	ie_status_conta 			= ''P'' ';

if (ie_somente_selecionada_p = 'S') then
	ds_sql_where_w	:= ds_sql_where_w  || ' and nr_sequencia = '||nr_sequencia_p;
end if;

if (ie_somente_terc_lib_w = 'S') and (ie_terc_liberados_p <> '') then
	ds_sql_where_w := ds_sql_where_w ||' and nr_seq_terceiro in ('||ie_terc_liberados_p||')';
end if;

if (ie_sobrepor_p = 'S') then
	ds_sql_where_w := ds_sql_where_w || ' and dt_vencimento is not null ';
elsif (ie_sobrepor_p = 'N') then
	ds_sql_where_w := ds_sql_where_w || ' and dt_vencimento is null ';
end if;

CALL Exec_sql_Dinamico('Tasy', ds_comando_w || ds_sql_where_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_vencimento_mes ( ie_terc_liberados_p text, nr_sequencia_p text, ie_somente_selecionada_p text, dt_venc_p timestamp, dt_ref_p timestamp, ie_sobrepor_p text, nm_usuario_p text) FROM PUBLIC;
