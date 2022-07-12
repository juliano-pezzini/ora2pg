-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_legenda_alergia_agenda (dt_liberacao_p timestamp, dt_inativacao_p timestamp, dt_fim_p timestamp, dt_assinatura_p timestamp, ie_pendencia_assinatura_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_legenda_w bigint;
ie_liberar_hist_saude_w varchar(1);


BEGIN

select	coalesce(ie_liberar_hist_saude,'S')
into STRICT	ie_liberar_hist_saude_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (ie_liberar_hist_saude_w = 'S') then
	begin

		if (coalesce(dt_liberacao_p::text, '') = '') then
			nr_seq_legenda_w := 1385;
		elsif (dt_inativacao_p IS NOT NULL AND dt_inativacao_p::text <> '') then
			nr_seq_legenda_w := 1386;
		elsif ((dt_fim_p IS NOT NULL AND dt_fim_p::text <> '')
			and dt_fim_p >= clock_timestamp() ) then
			nr_seq_legenda_w := 1387;
		elsif ((dt_liberacao_p IS NOT NULL AND dt_liberacao_p::text <> '')
			and coalesce(dt_inativacao_p::text, '') = ''
			and coalesce(dt_assinatura_p::text, '') = ''
			and ie_pendencia_assinatura_p = 'S') then
			nr_seq_legenda_w := 4348;
		end if;
	end;
else
	if (dt_inativacao_p IS NOT NULL AND dt_inativacao_p::text <> '') then
		nr_seq_legenda_w := 1386;
	end if;
end if;

return	nr_seq_legenda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_legenda_alergia_agenda (dt_liberacao_p timestamp, dt_inativacao_p timestamp, dt_fim_p timestamp, dt_assinatura_p timestamp, ie_pendencia_assinatura_p text) FROM PUBLIC;
