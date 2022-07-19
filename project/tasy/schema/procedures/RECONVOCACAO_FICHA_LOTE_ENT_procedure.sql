-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reconvocacao_ficha_lote_ent ( nr_seq_ficha_p bigint, ds_lista_exames_p text, nm_usuario_p text, ie_area_busca_p text) AS $body$
DECLARE

			
nr_seq_lote_sec_w	bigint;
nr_lote_w		bigint;
nr_seq_instituicao_w	bigint;
nr_seq_novo_lote_w	bigint;
nr_seq_nova_ficha_w	bigint;
nr_seq_exame_w		bigint;
cd_material_exame_w	varchar(20);
cd_pessoa_fisica_w	varchar(10);
nr_seq_reconvocado_w	bigint;
nr_seq_material_w		bigint;
nr_seq_resultado_w		bigint;
nr_prescricao_w			bigint;
qt_resultado_w			bigint;
ds_resultado_w			varchar(255);
nr_seq_prescr_w			integer;
qt_dias_prev_w			bigint;
dt_prevista_item_w		timestamp;
ie_tipo_busca_crit_w   	varchar(1);
nr_seq_lote_w		bigint;
nr_valor_param_w		bigint;
qt_itens_rec_w			bigint;

break varchar(2):= chr(13) || chr(10);

C01 CURSOR FOR
	SELECT	nr_seq_exame,
		cd_material_exame		
	from	lote_ent_sec_ficha_exam
	where	nr_seq_ficha = nr_seq_ficha_p
	and	obter_se_contido(nr_sequencia, ds_lista_exames_p) = 'S';
	

BEGIN
if (nr_seq_ficha_p IS NOT NULL AND nr_seq_ficha_p::text <> '') and (ds_lista_exames_p IS NOT NULL AND ds_lista_exames_p::text <> '') then
	select	max(nr_seq_lote_sec),
			max(cd_pessoa_fisica),
			max(nr_prescricao)
	into STRICT	nr_seq_lote_w,
			cd_pessoa_fisica_w,
			nr_prescricao_w
	from	lote_ent_sec_ficha
	where	nr_sequencia = nr_seq_ficha_p;
	
	update	lote_ent_sec_ficha
	set		ie_tipo_ficha = 'R'
	where	nr_sequencia = nr_seq_ficha_p;	
	
	--Insere as informacoes do lote
	
	select 	coalesce(max(nr_sequencia), 0)
	into STRICT	nr_seq_reconvocado_w
	from	lote_ent_reconvocado
	where	nr_seq_ficha_lote = nr_seq_ficha_p
	and		coalesce(dt_suspensao_rec::text, '') = ''
  and   coalesce(ie_urgencia, 'N') = 'N';

	if (coalesce(nr_seq_reconvocado_w, 0) = 0) then
		select 	nextval('lote_ent_reconvocado_seq')
		into STRICT	nr_seq_reconvocado_w
		;
		
		insert into lote_ent_reconvocado(	
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			nr_seq_lote_sec,
			nr_seq_ficha_lote,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_area_busca
		) values (
			nr_seq_reconvocado_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			nr_seq_lote_w,
			nr_seq_ficha_p,
			clock_timestamp(),
			nm_usuario_p,
			coalesce(ie_area_busca_p, 'A')
		);
	
	end if;
	
	--Insere os exames
	open C01;
	loop
	fetch C01 into	
		nr_seq_exame_w,
		cd_material_exame_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	max(Obter_Material_Exame_Lab('', cd_material_exame_w, 1))
		into STRICT	nr_seq_material_w
		;
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_prescr_w
		from		prescr_procedimento
		where	nr_prescricao = nr_prescricao_w
		and		nr_seq_exame = nr_seq_exame_w;
		
		select	max(nr_seq_resultado)
		into STRICT	nr_seq_resultado_w
		from	exame_lab_resultado
		where	nr_prescricao = nr_prescricao_w;
		
		select	max(coalesce(qt_resultado, pr_resultado)),
			max(ds_resultado)
		into STRICT	qt_resultado_w,
			ds_resultado_w
		from	exame_lab_result_item
		where	nr_seq_resultado = nr_seq_resultado_w
		and		nr_seq_prescr = nr_seq_prescr_w;
		
		if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') and (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then

			select	coalesce((lab_cons_valor_result_lote(nr_seq_exame_w, nr_seq_material_w, qt_resultado_w, ds_resultado_w, nr_prescricao_w, nr_seq_prescr_w, 5))::numeric , 0)
			into STRICT	qt_dias_prev_w
			;
		
		end if;
		
		if (qt_dias_prev_w > 0) then
			dt_prevista_item_w := clock_timestamp() + qt_dias_prev_w;
		else
			dt_prevista_item_w := clock_timestamp();	
		end if;
		
		select 	CASE WHEN count(*)=0 THEN  'A'  ELSE 'P' END
		into STRICT	ie_tipo_busca_crit_w
		from	LAB_VALOR_PADRAO_CRITERIO a
		where	a.nr_seq_exame = nr_seq_exame_w
		and (coalesce(a.IE_GERAR_BUSCA_ATIVA, 'A') = 'P');
			
		if (ie_tipo_busca_crit_w = 'P') then
		
			select	max(lab_cons_valor_result_lote(nr_seq_exame_w, nr_seq_material_w, qt_resultado_w, ds_resultado_w, nr_prescricao_w, nr_seq_prescr_w, 6))
			into STRICT	ie_tipo_busca_crit_w
			;

            if coalesce(ie_tipo_busca_crit_w::text, '') = '' then
                CALL gravar_log_lab_pragma(
                    cd_log_p => 55,
                    ds_log_p => dbms_utility.format_call_stack || break || break ||
                        'nr_seq_exame_w'    || coalesce(to_char(nr_seq_exame_w), 'null') || break ||
                        'nr_seq_material_w' || coalesce(to_char(nr_seq_material_w), 'null') || break ||
                        'qt_resultado_w'    || coalesce(to_char(qt_resultado_w), 'null') || break ||
                        'ds_resultado_w'    || coalesce(to_char(ds_resultado_w), 'null') || break ||
                        'nr_prescricao_w'   || coalesce(to_char(nr_prescricao_w), 'null') || break ||
                        'nr_seq_prescr_w'   || coalesce(to_char(nr_seq_prescr_w), 'null') || break,
                    nm_usuario_p => coalesce(nm_usuario_p, wheb_usuario_pck.get_nm_usuario()),
                    nr_prescricao_p => coalesce(nr_prescricao_w, 55),
                    ds_integracao_p => coalesce(nr_seq_prescr_w, 55)
                );
            end if;
				
		end if;

	
		nr_valor_param_w := Obter_Param_Usuario(10060, 62, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, nr_valor_param_w);
	
		select 	count(*)
		into STRICT	qt_itens_rec_w
		from	lote_ent_reconvocado_item
		where	nr_seq_reconvocado = nr_seq_reconvocado_w
		and		nr_seq_exame = nr_seq_exame_w;
	
		if (coalesce(qt_itens_rec_w, 0) = 0) then
	
			insert	into LOTE_ENT_RECONVOCADO_ITEM(
				NR_SEQUENCIA,
				NR_SEQ_EXAME,
				DT_ATUALIZACAO,
				NM_USUARIO,
				CD_MATERIAL_EXAME,
				NR_SEQ_RECONVOCADO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				IE_TIPO_BUSCA,
				DT_PREVISTA,
				NR_PRESCRICAO,
				NR_SEQ_PRESCR,
				NR_SEQ_STATUS_RECONV,
				IE_URGENCIA
			) values (
				nextval('lote_ent_reconvocado_item_seq'),
				nr_seq_exame_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_material_exame_w,
				nr_seq_reconvocado_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_tipo_busca_crit_w,
				dt_prevista_item_w,
				nr_prescricao_w,
				nr_seq_prescr_w,
				nr_valor_param_w,
				'N'
			);		
		
		end if;
			
		end;
	end loop;
	close C01;	
	
end if;	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reconvocacao_ficha_lote_ent ( nr_seq_ficha_p bigint, ds_lista_exames_p text, nm_usuario_p text, ie_area_busca_p text) FROM PUBLIC;

