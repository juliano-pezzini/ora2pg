-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prescr_solucao_beforepost ( nr_atendimento_p bigint, cd_dieta_p bigint, dt_prescricao_p timestamp, qt_parametro_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, nr_dia_util_p INOUT bigint, nr_sequencia_p bigint) AS $body$
DECLARE


ds_mensagem_w			varchar(2000);
ie_mensagem_qtd_w		varchar(1);
ie_obriga_qt_w			varchar(1);
ie_permite_dieta_w		varchar(1);
ie_permite_dup_dieta_w		varchar(1);
ie_existe_dieta_w		varchar(1) := 'N';
nr_dia_util_w			bigint;

BEGIN

ie_mensagem_qtd_w 	:= obter_valor_param_usuario(924, 292, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_permite_dup_dieta_w 	:= obter_valor_param_usuario(924, 904, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

if (coalesce(ds_mensagem_w::text, '') = '') and (ie_mensagem_qtd_w = 'S') then
	begin
	select	upper(ie_obriga_qt)
	into STRICT	ie_obriga_qt_w
	from 	dieta
        where  	cd_dieta = cd_dieta_p;

	if (ie_obriga_qt_w = 'S') and (coalesce(qt_parametro_p::text, '') = '') then
		begin
		-- Quantidade não informada!
		ds_mensagem_w := obter_texto_tasy(99311,wheb_usuario_pck.get_nr_seq_idioma);
		end;
	end if;
	end;
end if;

if (coalesce(ds_mensagem_w::text, '') = '') then
	begin
	ie_permite_dieta_w	:= Obter_Se_dieta_valida(cd_dieta_p, cd_estabelecimento_p, dt_prescricao_p);

	if (ie_permite_dieta_w = 'N') then
		begin
		-- Esta dieta não pode ser prescrita neste dia da semana conforme cadastros!
		ds_mensagem_w := obter_texto_tasy(99312,wheb_usuario_pck.get_nr_seq_idioma);
		end;
	end if;
	end;
end if;

if (cd_dieta_p IS NOT NULL AND cd_dieta_p::text <> '') then
	begin

	select	coalesce(max(a.nr_dia_util),0) + 1
	into STRICT	nr_dia_util_w
	from	prescr_dieta a,
		prescr_medica b
	where	a.nr_prescricao = b.nr_prescricao
	and     trunc(b.dt_prescricao)   = trunc(to_date(dt_prescricao_p,'dd/mm/yyyy  hh24:mi:ss') - 1)
	and     b.nr_atendimento = nr_atendimento_p
	and     a.cd_dieta = cd_dieta_p
	and     b.nr_prescricao <> nr_prescricao_p
	and     coalesce(b.dt_suspensao::text, '') = ''
	and     coalesce(a.dt_suspensao::text, '') = '';

	if (ie_permite_dup_dieta_w = 'N') then
		begin
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_existe_dieta_w
		from	prescr_dieta
		where	nr_prescricao	= nr_prescricao_p
		and	cd_dieta	= cd_dieta_p
		AND NOT EXISTS (SELECT	nr_sequencia
						FROM	prescr_dieta
						WHERE	nr_prescricao	= nr_prescricao_p
						AND	cd_dieta	= cd_dieta_p
						AND nr_sequencia = nr_sequencia_p);

		if (ie_existe_dieta_w = 'S') then
			begin
			-- Só é permitido prescrever uma dieta deste tipo por prescrição. Parâmetro [904]
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(99299);
			end;
		end if;
		end;
	end if;
	end;
end if;
ds_mensagem_p := ds_mensagem_w;
nr_dia_util_p := nr_dia_util_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prescr_solucao_beforepost ( nr_atendimento_p bigint, cd_dieta_p bigint, dt_prescricao_p timestamp, qt_parametro_p bigint, nr_prescricao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, nr_dia_util_p INOUT bigint, nr_sequencia_p bigint) FROM PUBLIC;
