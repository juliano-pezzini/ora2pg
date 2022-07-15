-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_alta_lib_proc ( cd_motivo_alta_p bigint, nr_atendimento_p bigint, ds_erro_p INOUT text, ds_erro_p2 INOUT text, ds_erro_p3 INOUT text) AS $body$
DECLARE


qt_existe_regra_w	integer;	
cd_motivo_alta_w	integer;	
ie_liberado_w		varchar(1) := 'X';
cd_motivo_alta_ok_w	integer;	
ds_motivos_w		varchar(4000);
ds_motivo_w		varchar(255);
ds_erro_w		varchar(2000) := '';
	
c01 CURSOR FOR
SELECT	a.cd_motivo_alta,
	substr(OBTER_DESC_MOTIVO_ALTA(a.cd_motivo_alta),1,255)
from	REGRA_MOTIVO_ALTA_PROC a
where	a.ie_situacao = 'A'
and	exists (SELECT 1
		from	procedimento_paciente x
		where	x.nr_atendimento = nr_atendimento_p
		and 	x.cd_procedimento  = a.cd_procedimento
		and	x.ie_origem_proced = a.ie_origem_proced
		and	(((coalesce(x.cd_motivo_exc_conta::text, '') = '') 
		and (coalesce(a.ie_considerar_nao_excluidos,'N') = 'S'))
		or (coalesce(a.ie_considerar_nao_excluidos,'N') = 'N')));


BEGIN

open C01;
loop
fetch C01 into	
	cd_motivo_alta_w,
	ds_motivo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_motivos_w	:= ds_motivos_w || chr(10)|| ds_motivo_w;
	
	if (cd_motivo_alta_w = cd_motivo_alta_p) then
		begin
		ie_liberado_w	:=	'S';			
		end;
	end if;
	
	if (ie_liberado_w <> 'S') and (cd_motivo_alta_w <> cd_motivo_alta_p) then
		ie_liberado_w	:=	'N';
	end if;
	
	end;
end loop;
close C01;


if (ie_liberado_w = 'N') then
	begin
	ds_erro_w	:=	wheb_mensagem_pck.get_texto(279971, 'DS_MOTIVOS_P=' || ds_motivos_w);
	end;
end if;	

ds_erro_p := substr(ds_erro_w,1,250);
ds_erro_p2 := substr(ds_erro_w,251,250);
ds_erro_p3 := substr(ds_erro_w,501,250);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_alta_lib_proc ( cd_motivo_alta_p bigint, nr_atendimento_p bigint, ds_erro_p INOUT text, ds_erro_p2 INOUT text, ds_erro_p3 INOUT text) FROM PUBLIC;

