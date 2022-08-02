-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_imp_result_nat30 ( dt_realizado_p timestamp, ds_lote_kit_p text, nr_cutoff_exame_1_p text, nr_cutoff_exame_2_p text, vl_exame_1_p text, vl_ct_1_p text, vl_exame_1_rna_p text, vl_exame_2_p text, vl_ct_2_p text, vl_exame_2_rna_p text, cd_tubo_deter_p text, cd_barras_p text, dt_validade_kit_nat_p text, ds_fabricante_kit_nat_p text, ds_placa_pcr_p text, ds_placa_extracao_p text, nm_usuario_p text) AS $body$
DECLARE

						
nr_seq_exame_lote_w	bigint;
nr_seq_exame_w		bigint;
dt_liberacao_w		timestamp;
ie_tipo_resultado_w	varchar(2);

vl_exame_atual_w	varchar(50);
vl_exame_rna_w		varchar(255);
ds_ct_w			varchar(50);
nr_cutoff_w		double precision;
cd_barras_w		varchar(13);
dt_validade_kit_nat_w	timestamp;

C01 CURSOR FOR
	SELECT	vl_exame_1_p,
			elimina_acentuacao(vl_exame_1_rna_p) vl_exame_1_rna,
			vl_ct_1_p,
			nr_cutoff_exame_1_p
	
	
union

	SELECT	vl_exame_2_p,
			elimina_acentuacao(vl_exame_2_rna_p) vl_exame_2_rna,
			vl_ct_2_p,
			nr_cutoff_exame_2_p
	;
	

BEGIN
	if (cd_barras_p IS NOT NULL AND cd_barras_p::text <> '') then		
		
		cd_barras_w := substr(replace(cd_barras_p, '=', ''), 1, 13);
		
		select 	max(a.nr_sequencia)
		into STRICT	nr_seq_exame_lote_w
		from	san_exame_lote a,
			san_doacao b
		where	a.nr_seq_doacao = b.nr_sequencia
		and	obter_isbt_doador(a.nr_seq_doacao, NULL,'I')  = cd_barras_w;
		
		if (coalesce(nr_seq_exame_lote_w::text, '') = '') then
			CALL gravar_log_tasy(9246, obter_desc_expressao(686155) || cd_barras_w, nm_usuario_p);
			
		else
	
			open C01;
			loop
			fetch C01 into	
				vl_exame_atual_w,
				vl_exame_rna_w,
				ds_ct_w,
				nr_cutoff_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
					
				select	max(nr_seq_exame)
				into STRICT 	nr_seq_exame_w
				from 	san_exame_integracao
				where 	cd_exame_integracao = vl_exame_atual_w
				and	cd_tipo_integracao = '3';
				
				if (coalesce(nr_seq_exame_w::text, '') = '') then						
					CALL gravar_log_tasy(9246, wheb_mensagem_pck.get_texto(793520, 'CD_EXAME='||vl_exame_atual_w)||' ' || cd_barras_w, nm_usuario_p);	
				elsif (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
					
					select	max(dt_liberacao)
					into STRICT 	dt_liberacao_w
					from	san_exame_realizado
					where 	nr_seq_exame_lote = nr_seq_exame_lote_w
					and	nr_seq_exame = nr_seq_exame_w;
				
					if (coalesce(nr_seq_exame_lote_w::text, '') = '') then						
						CALL gravar_log_tasy(9246, wheb_mensagem_pck.get_texto(793521,
													'CD_EXAME='||vl_exame_atual_w||
													';NR_SEQ_EXAME_LOTE='||nr_seq_exame_lote_w||
													';CD_BARRAS='||cd_barras_w), nm_usuario_p);
					elsif (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then
						CALL gravar_log_tasy(9246, wheb_mensagem_pck.get_texto(793523,
											'CD_EXAME='||vl_exame_atual_w||
											';CD_BARRAS='||cd_barras_w||
											';DT_LIBERACAO='||dt_liberacao_w), nm_usuario_p);
					else					
						begin
						
						if (dt_validade_kit_nat_p IS NOT NULL AND dt_validade_kit_nat_p::text <> '') then
							dt_validade_kit_nat_w	:= PKG_DATE_UTILS.End_of('01/'||dt_validade_kit_nat_p,'MONTH');
						end if;				
					
						if	((vl_exame_rna_w = 'DETECTAVEL') or (vl_exame_rna_w = 'DETECTVEL')) then
							vl_exame_rna_w := obter_desc_expressao(296109);
						elsif 	((vl_exame_rna_w = 'NAODETECTAVEL') or (vl_exame_rna_w = 'NODETECTVEL')) then
							vl_exame_rna_w := obter_desc_expressao(328863);
						else
							vl_exame_rna_w := null;
						end if;
						
						update	san_exame_realizado set
							ds_ct			= ds_ct_w,
							nr_cutoff 		= nr_cutoff_w,
							nr_cutoff_desc 		= trim(both TO_CHAR(nr_cutoff_w,'999,999,990.000')),
							dt_realizado		= coalesce(dt_realizado_p,clock_timestamp()),
							ds_resultado		= vl_exame_rna_w,
							ds_lote_kit		= coalesce(ds_lote_kit_p,ds_lote_kit),
							cd_tubo_determinacao	= coalesce(cd_tubo_deter_p,cd_tubo_determinacao),
							dt_vencimento_lote	= coalesce(dt_validade_kit_nat_w, dt_vencimento_lote),
							ds_fabricante		= coalesce(substr(ds_fabricante_kit_nat_p,1,50), ds_fabricante),
							ds_placa_pcr		= coalesce(substr(ds_placa_pcr_p,1,8), ds_placa_pcr),
							ds_placa_extracao	= coalesce(substr(ds_placa_extracao_p,1,22), ds_placa_extracao)
						where 	nr_seq_exame_lote 	= nr_seq_exame_lote_w
						and	nr_seq_exame 		= nr_seq_exame_w
						and	coalesce(dt_liberacao::text, '') = '';
						
						exception
							when others then	
							CALL gravar_log_tasy(9246, wheb_mensagem_pck.get_texto(793575,
												'VL_EXAME_ATUAL='||vl_exame_atual_w||
												';CD_BARRAS='||cd_barras_w||
												';DS_CT='||ds_ct_w), nm_usuario_p);
						end;
						
					end if;
					
				end if;
			end;
			end loop;
			close C01;

		end if;
	
	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_imp_result_nat30 ( dt_realizado_p timestamp, ds_lote_kit_p text, nr_cutoff_exame_1_p text, nr_cutoff_exame_2_p text, vl_exame_1_p text, vl_ct_1_p text, vl_exame_1_rna_p text, vl_exame_2_p text, vl_ct_2_p text, vl_exame_2_rna_p text, cd_tubo_deter_p text, cd_barras_p text, dt_validade_kit_nat_p text, ds_fabricante_kit_nat_p text, ds_placa_pcr_p text, ds_placa_extracao_p text, nm_usuario_p text) FROM PUBLIC;

