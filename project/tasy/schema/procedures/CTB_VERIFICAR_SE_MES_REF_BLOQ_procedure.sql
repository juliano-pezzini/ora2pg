-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_verificar_se_mes_ref_bloq ( nr_seq_mes_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


/*
Esta procedure retorna se o mês está bloqueado para atualização por determinado usuário.
*/
nm_usuario_bloqueio_w	varchar(15);
dt_bloqueio_w		timestamp;
dt_tentativa_w		timestamp;

qt_min_controle_usuario_w	bigint := 1;
qt_min_diferenca_w		double precision;
ds_min_diferenca_w	varchar(255);

ds_retorno_w		varchar(255);
ie_bloqueado_w		varchar(1);


BEGIN

ie_bloqueado_w		:= 'N';

select	dt_bloqueio,
	nm_usuario_bloqueio
into STRICT	dt_bloqueio_w,
	nm_usuario_bloqueio_w
from	ctb_mes_ref a
where	nr_sequencia	= nr_seq_mes_p;

if (coalesce(dt_bloqueio_w::text, '') = '') then
	update	ctb_mes_ref
	set	dt_bloqueio = clock_timestamp(),
		nm_usuario_bloqueio = nm_usuario_p
	where	nr_sequencia = nr_seq_mes_p;

	ie_bloqueado_w	:= 'N';
elsif (nm_usuario_bloqueio_w = nm_usuario_p) then
	update	ctb_mes_ref
	set	dt_bloqueio = clock_timestamp()
	where	nr_sequencia = nr_seq_mes_p;

	ie_bloqueado_w	:= 'N';
elsif (nm_usuario_bloqueio_w <> nm_usuario_p) then
	begin
	dt_tentativa_w		:= clock_timestamp();
	qt_min_diferenca_w	:= ((dt_tentativa_w - dt_bloqueio_w) * 1440);

	/*Pega o tempo para controle parâmetro [87] do Contabilidade*/

	qt_min_controle_usuario_w := obter_param_usuario(923, 87, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_min_controle_usuario_w);

	if (qt_min_diferenca_w < qt_min_controle_usuario_w) then
		ds_min_diferenca_w := trim(both to_char((qt_min_controle_usuario_w - qt_min_diferenca_w),'99999990.00'));
		ie_bloqueado_w	:= 'S';
	else
		update	ctb_mes_ref
		set	dt_bloqueio = clock_timestamp(),
			nm_usuario_bloqueio = nm_usuario_p
		where	nr_sequencia = nr_seq_mes_p;

		ie_bloqueado_w	:= 'N';
	end if;

	end;
end if;

if (ie_bloqueado_w = 'S') then
	ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(277671) || nm_usuario_bloqueio_w || '!' ||  chr(13) || chr(13) ||
				WHEB_MENSAGEM_PCK.get_texto(277674) || to_char(dt_bloqueio_w,'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
				WHEB_MENSAGEM_PCK.get_texto(277675) || to_char(dt_tentativa_w, 'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
				WHEB_MENSAGEM_PCK.get_texto(277676) || ds_min_diferenca_w || ' min';
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_verificar_se_mes_ref_bloq ( nr_seq_mes_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
