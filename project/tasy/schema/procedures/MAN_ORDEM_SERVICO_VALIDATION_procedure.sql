-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_ordem_servico_validation ( ie_insert_update_p text, new_nm_usuario_p text, old_nm_usuario_p text, new_nr_sequencia_p bigint, old_nr_sequencia_p bigint, new_nr_seq_estagio_p bigint, old_nr_seq_estagio_p bigint, new_nr_seq_grupo_des_p bigint, old_nr_seq_grupo_des_p bigint, new_nr_seq_localizacao_p bigint, old_nr_seq_localizacao_p bigint, new_ie_classificacao_p text, old_ie_classificacao_p text, new_cd_funcao_p bigint, old_cd_funcao_p bigint, new_ie_origem_os_p bigint, old_ie_origem_os_p bigint, new_ie_plataforma_p text, old_ie_plataforma_p text, ie_complaint_p text, ie_classificacao_cliente_p text, ie_tipo_ordem_p bigint) AS $body$
DECLARE


nm_user_w		varchar(15);
qt_w			bigint;
ie_terceiro_w		varchar(1);
ie_aguarda_cliente_w	varchar(1);
ds_prs_list_w		varchar(4000);
ds_macro_w		varchar(4000);
ie_open_ccb_w		varchar(1);
ie_pending_sme_w	varchar(1);
ie_new_suporte_w	man_estagio_processo.ie_suporte%type;
ie_old_suporte_w	man_estagio_processo.ie_suporte%type;
ie_permite_aval_reg_w	funcao_parametro.vl_parametro%type;
ie_old_desenv_w	        man_estagio_processo.ie_desenv%type;
ie_old_tec_w	        man_estagio_processo.ie_tecnologia%type;
ie_new_testes_w	        man_estagio_processo.ie_testes%type;

/*
This procedure is called inside the trigger MAN_ORDEM_SERVICO_ATUAL too.
Keep in mind to not make any select at the MAN_ORDEM_SERVICO table or it may
cause a Mutant trigger error
*/
  reg RECORD;

BEGIN


if (obter_se_base_corp = 'S' or obter_se_base_wheb = 'S') then
	begin
		ie_terceiro_w := man_obter_se_loc_terceiro(new_nr_seq_localizacao_p);
	
		if (ie_insert_update_p = 'U') and (ie_terceiro_w = 'S') and (upper(new_nm_usuario_p) != 'WEBSERVICE') then
			begin
				-- Criado para ter controle se antes de realizar a passagem de OS para outro grupo, foi enviada uma informacao relevante para o cliente.
				select	count(*)
				into STRICT	qt_w
				from	man_ordem_serv_tecnico
				where	nr_seq_ordem_serv = old_nr_sequencia_p
				and		nr_seq_tipo = 1
				and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
			
				if (qt_w < 1) then	
					if (new_nr_seq_grupo_des_p <> old_nr_seq_grupo_des_p) then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(497803);
					end if;
		
					if (new_nr_seq_estagio_p <> old_nr_seq_estagio_p) and (old_nr_seq_estagio_p in (231, 1051, 1731)) then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(686522);
					end if;
				end if;
			end;
		end if;
	
		select	coalesce(max(ie_suporte), 'N')
		into STRICT	ie_new_suporte_w
		from	man_estagio_processo mep
		where	mep.nr_sequencia = new_nr_seq_estagio_p;
		
		select	coalesce(max(ie_suporte), 'N')
		into STRICT	ie_old_suporte_w
		from	man_estagio_processo mep
		where	mep.nr_sequencia = old_nr_seq_estagio_p;

                select	coalesce(max(ie_desenv), 'N')
		into STRICT	ie_old_desenv_w
		from	man_estagio_processo mep
		where	mep.nr_sequencia = old_nr_seq_estagio_p;

                select	coalesce(max(ie_tecnologia), 'N')
		into STRICT	ie_old_tec_w
		from	man_estagio_processo mep
		where	mep.nr_sequencia = old_nr_seq_estagio_p;

                select	coalesce(max(ie_testes), 'N')
		into STRICT	ie_new_testes_w
		from	man_estagio_processo mep
		where	mep.nr_sequencia = new_nr_seq_estagio_p;
	
		ie_permite_aval_reg_w := coalesce(obter_valor_param_usuario(297,106,wheb_usuario_pck.get_cd_perfil,new_nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento),'S');

		if (new_nr_seq_estagio_p <> old_nr_seq_estagio_p) and (new_ie_plataforma_p = 'H') and (old_nr_seq_estagio_p <> 511) and (upper(new_nm_usuario_p) != 'WEBSERVICE') and
			((new_nr_seq_estagio_p in (2,9,721)) or (ie_new_suporte_w = 'S' and (ie_old_desenv_w = 'S' or ie_old_tec_w = 'S')) or (ie_new_suporte_w = 'S' and ie_old_suporte_w = 'S' and ie_permite_aval_reg_w = 'N')) then
			begin
				if	((coalesce(ie_complaint_p::text, '') = '') and
					((ie_terceiro_w = 'S' AND new_ie_classificacao_p = 'E') or 
					((ie_classificacao_cliente_p = 'A') and (ie_tipo_ordem_p <> 28) and (ie_terceiro_w = 'N')))) then
					begin
						if (	ie_new_suporte_w = 'S'
							and (ie_old_desenv_w = 'S' or ie_old_tec_w = 'S')) then
							begin
								CALL wheb_mensagem_pck.exibir_mensagem_abort(1105313);
							end;
						else
							begin
                                                                if (new_nr_seq_estagio_p in (2,9,721) or (ie_new_suporte_w = 'S' and ie_old_suporte_w = 'S' and ie_permite_aval_reg_w = 'N')) then
                                                                        begin
                                                                                CALL wheb_mensagem_pck.exibir_mensagem_abort(1094246);
                                                                        end;
                                                                end if;								
							end;
						end if;
					end;
				end if;
			end;
		end if;

		if (	new_nr_seq_estagio_p <> old_nr_seq_estagio_p
			and	new_nr_seq_estagio_p in (2, 9, 721)) then	
			begin
				select	coalesce(max('S'), 'N')
				into STRICT	ie_pending_sme_w
				from	man_ordem_serv_impacto mosi,
						man_ordem_serv_imp_pr mosip,
						man_ordem_serv_imp_resp mosir
				where	mosi.nr_sequencia = mosip.nr_seq_impacto 
				and	coalesce(mosi.dt_aprovacao::text, '') = '' 
				and	(mosi.dt_liberacao IS NOT NULL AND mosi.dt_liberacao::text <> '') 
				and	mosir.nr_seq_impacto = mosi.nr_sequencia
				and	coalesce(mosir.dt_aprovacao::text, '') = ''
				and	coalesce(ie_resposta, 'N') = 'S'
				and	not exists ( 
								SELECT	1 
								from	man_ordem_serv_aprov_ccb x 
								where	x.nr_seq_impacto = mosi.nr_sequencia 
								and	(x.dt_reprovacao IS NOT NULL AND x.dt_reprovacao::text <> '') 
							) 
				and	mosi.nr_seq_ordem_serv = new_nr_sequencia_p;			
			
				if (ie_pending_sme_w = 'S') then
					begin
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1093090);
					end;
				end if;		
			
				for reg in (
						SELECT	rpr.cd_prs_id
						from	man_ordem_serv_impacto mosi,
							man_ordem_serv_imp_pr mosip,
							reg_product_requirement rpr
						where	mosi.nr_sequencia = mosip.nr_seq_impacto
						and	rpr.nr_sequencia = mosip.nr_product_requirement
						and	mosip.ie_impacto_requisito in ('I', 'A')
						and (mosi.dt_liberacao IS NOT NULL AND mosi.dt_liberacao::text <> '')
						and	coalesce(rpr.dt_liberacao::text, '') = ''
						and	not exists (
										SELECT	1
										from	man_ordem_serv_aprov_ccb x
										where	x.nr_seq_impacto = mosi.nr_sequencia
										and	(x.dt_reprovacao IS NOT NULL AND x.dt_reprovacao::text <> '')
									)
						and	mosi.nr_seq_ordem_serv = new_nr_sequencia_p
						and	coalesce(rpr.ie_situacao ,'A') <> 'I'
						order by 1
					) loop
						if (length(ds_prs_list_w || reg.cd_prs_id || ' ,') < 4000) then
							begin
								ds_prs_list_w := ds_prs_list_w || reg.cd_prs_id || ' ,';
							end;
						end if;
					end loop;

				if (length(ds_prs_list_w) > 0) then
					begin
						ds_macro_w := substr('DS_LISTA=' || ds_prs_list_w, 1, 4000);
						ds_macro_w := substr(ds_macro_w, 1, length(ds_macro_w) - 2);
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1082501, ds_macro_w);
					end;
				end if;
			
				select	coalesce(max('S'), 'N')
				into STRICT	ie_open_ccb_w
				from	man_ordem_serv_impacto mosi,
					man_ordem_serv_imp_pr mosip
				where	mosi.nr_sequencia = mosip.nr_seq_impacto
				and	coalesce(mosi.dt_aprovacao::text, '') = ''
				and	(mosi.dt_liberacao IS NOT NULL AND mosi.dt_liberacao::text <> '')
				and	not exists (
								SELECT	1
								from	man_ordem_serv_aprov_ccb x
								where	x.nr_seq_impacto = mosi.nr_sequencia
								and	(x.dt_reprovacao IS NOT NULL AND x.dt_reprovacao::text <> '')
							)
				and	mosi.nr_seq_ordem_serv = new_nr_sequencia_p
				order by 1;
			
				if (ie_open_ccb_w = 'S') then
					begin
						CALL wheb_mensagem_pck.exibir_mensagem_abort(1083539);
					end;
				end if;
			end;
		end if;	
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_ordem_servico_validation ( ie_insert_update_p text, new_nm_usuario_p text, old_nm_usuario_p text, new_nr_sequencia_p bigint, old_nr_sequencia_p bigint, new_nr_seq_estagio_p bigint, old_nr_seq_estagio_p bigint, new_nr_seq_grupo_des_p bigint, old_nr_seq_grupo_des_p bigint, new_nr_seq_localizacao_p bigint, old_nr_seq_localizacao_p bigint, new_ie_classificacao_p text, old_ie_classificacao_p text, new_cd_funcao_p bigint, old_cd_funcao_p bigint, new_ie_origem_os_p bigint, old_ie_origem_os_p bigint, new_ie_plataforma_p text, old_ie_plataforma_p text, ie_complaint_p text, ie_classificacao_cliente_p text, ie_tipo_ordem_p bigint) FROM PUBLIC;
