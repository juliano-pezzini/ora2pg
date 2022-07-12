-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_bloq_musc ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_escala_w				bigint := 0;
nr_seq_tipo_avaliacao_w	bigint;
qt_registros			bigint := 0;
ds_escala_w				varchar(3500) := '';
ds_escala_temp_w		varchar(255);
nm_usuario_w			varchar(255);
cd_escala_verifica_w	varchar(255);
dt_atualizacao_w		timestamp := null;
dt_atualizacao_temp_w	timestamp;

C01 CURSOR FOR
	SELECT	nr_seq_tipo_avaliacao,
			nm_usuario,
			dt_atualizacao
	from	med_avaliacao_paciente
	where	nr_atendimento = nr_atendimento_p
	and 	(nr_seq_tipo_avaliacao IS NOT NULL AND nr_seq_tipo_avaliacao::text <> '')
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

C02 CURSOR FOR
	SELECT	distinct ie_escala,
			substr(obter_valor_dominio(1799,ie_escala),1,255) ds_escala
	from	espasticidade_escala_aval
	where	nr_seq_tipo_avaliacao = nr_seq_tipo_avaliacao_w;


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_tipo_avaliacao_w,
	nm_usuario_w,
	dt_atualizacao_temp_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if ((dt_atualizacao_temp_w > dt_atualizacao_w)or (coalesce(dt_atualizacao_w::text, '') = '')) then
		dt_atualizacao_w := dt_atualizacao_temp_w;
	end if;

	open C02;
	loop
	fetch C02 into
		cd_escala_w,
		ds_escala_temp_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
			if (cd_escala_w = 123) then
				select	count(*)
				into STRICT	qt_registros
				from	escala_ashworth
				where	nr_atendimento = nr_atendimento_p
				and 	dt_atualizacao > dt_atualizacao_temp_w;
			elsif (cd_escala_w = 132) then
				select	count(*)
				into STRICT	qt_registros
				from	escala_baylor
				where	nr_atendimento = nr_atendimento_p
				and 	dt_atualizacao > dt_atualizacao_temp_w;
			elsif (cd_escala_w = 134) then
				select	count(*)
				into STRICT	qt_registros
				from	escala_toronto
				where	nr_atendimento = nr_atendimento_p
				and 	dt_atualizacao > dt_atualizacao_temp_w;
			elsif (cd_escala_w = 137) then
				select	count(*)
				into STRICT	qt_registros
				from	escala_house_brackmann
				where	nr_atendimento = nr_atendimento_p
				and 	dt_atualizacao > dt_atualizacao_temp_w;
			end if;

			if (qt_registros = 0) then
				if (cd_escala_verifica_w IS NOT NULL AND cd_escala_verifica_w::text <> '') then
					if (obter_se_contido_entre_virgula(cd_escala_verifica_w, cd_escala_w) = 'N') then
						cd_escala_verifica_w := cd_escala_verifica_w || ',' || cd_escala_w;
						ds_escala_w := ds_escala_w || ', ' || ds_escala_temp_w;
					end if;
				else
					cd_escala_verifica_w := cd_escala_w;
					ds_escala_w := ds_escala_w || ds_escala_temp_w;
				end if;
			end if;
		end;
	end loop;
	close C02;

end loop;
close C01;

if (coalesce(ds_escala_w::text, '') = '') then
	ds_escala_w := '0';
else
	select 	count(*)
	into STRICT 	qt_registros
	from 	atend_toxina_item_hist
	where 	trunc(dt_atualizacao) = trunc(clock_timestamp())
	and 	nm_usuario = nm_usuario_w
	and		dt_atualizacao > dt_atualizacao_w;

	if (qt_registros = 0) then
		--É necessário o preenchimento da(s) escala(s) #@DS_ESCALAS#@ . Deseja preencher agora?
		ds_escala_w := wheb_mensagem_pck.get_texto(341307,'DS_ESCALAS='||ds_escala_w);
	else
		ds_escala_w := '0';
	end if;
end if;

return	ds_escala_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_bloq_musc ( nr_atendimento_p bigint) FROM PUBLIC;
