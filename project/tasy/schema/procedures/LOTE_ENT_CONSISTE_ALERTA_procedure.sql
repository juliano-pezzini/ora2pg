-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lote_ent_consiste_alerta ( ie_tipo_alerta_p text, nr_prescricao_p bigint, nr_corrida_p bigint, nr_seq_lote_p bigint, nr_seq_ficha_p bigint, nr_seq_reconvocado_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ds_mensagem_select_w		varchar(2000);
ds_comando_sql_w			varchar(2000);
ds_sep_bv_w					varchar(50);

C01 CURSOR FOR
	SELECT	DS_SQL_ALERTA
	from	LOTE_ENT_ALERTA_PROCESSO
	where	cd_tipo_alerta = ie_tipo_alerta_p
	and		ie_situacao = 'A';


BEGIN
ds_sep_bv_w	:= obter_separador_bv;

/*select	max(DS_SQL_ALERTA)
into	ds_comando_sql_w
from	LOTE_ENT_ALERTA_PROCESSO
where	cd_tipo_alerta = ie_tipo_alerta_p
and		ie_situacao = 'A';*/
open C01;
loop
fetch C01 into
	ds_comando_sql_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	--Secretaria/Lote de entrada
	if (ie_tipo_alerta_p = 'SEL') and (coalesce(nr_seq_lote_p,0) > 0) then

		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_seq_lote_p', nr_seq_lote_p);
		ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

	--Secretaria/Lote de entrada/Fichas
	elsif (ie_tipo_alerta_p = 'SELF') and (coalesce(nr_seq_lote_p,0) > 0) and (coalesce(nr_seq_ficha_p,0) > 0) then

		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_seq_lote_p', nr_seq_lote_p);
		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_seq_ficha_p', nr_seq_ficha_p);
		ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

	--Busca ativa/Gestão
	elsif (ie_tipo_alerta_p = 'BAG') and (coalesce(nr_seq_reconvocado_p,0) > 0) then

		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_seq_reconvocado_p', nr_seq_reconvocado_p);
		ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

	--Busca ativa/Monitoramento
	elsif (ie_tipo_alerta_p = 'BAM') and (coalesce(nr_seq_reconvocado_p,0) > 0) then

		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_seq_reconvocado_p', nr_seq_reconvocado_p);
		ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

	--Aprovação/Lote
	elsif (ie_tipo_alerta_p = 'APL') and (coalesce(nr_seq_lote_p,0) > 0) and (coalesce(nr_prescricao_p,0) > 0) then

		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_seq_lote_p', nr_seq_lote_p);
		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_prescricao_p', nr_prescricao_p);
		ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

	--Aprovação/Corrida
	elsif (ie_tipo_alerta_p = 'APC') and (coalesce(nr_corrida_p,0) > 0) then

		ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_corrida_p', nr_corrida_p);
		ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

	--Aprovação/Comuns
	elsif (ie_tipo_alerta_p = 'APCO') then

		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (coalesce(nr_prescricao_p,0) > 0) then

			ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_prescricao_p', nr_prescricao_p);
			ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

		elsif (nr_corrida_p IS NOT NULL AND nr_corrida_p::text <> '') and (coalesce(nr_corrida_p,0) > 0) then

			ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_corrida_p', nr_corrida_p);
			ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

		end if;

	--Aprovação/Massas
	elsif (ie_tipo_alerta_p = 'APCM') then

		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (coalesce(nr_prescricao_p,0) > 0) then

			ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_prescricao_p', nr_prescricao_p);
			ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

		elsif (nr_corrida_p IS NOT NULL AND nr_corrida_p::text <> '') and (coalesce(nr_corrida_p,0) > 0) then

			ds_comando_sql_w := replace(ds_comando_sql_w, ':nr_corrida_p', nr_corrida_p);
			ds_mensagem_select_w := ds_mensagem_select_w || Obter_select_concatenado_bv(ds_comando_sql_w,'','') || chr(13) || chr(10);

		end if;

	end if;


	end;
end loop;
close C01;

ds_retorno_p := ds_mensagem_select_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lote_ent_consiste_alerta ( ie_tipo_alerta_p text, nr_prescricao_p bigint, nr_corrida_p bigint, nr_seq_lote_p bigint, nr_seq_ficha_p bigint, nr_seq_reconvocado_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

