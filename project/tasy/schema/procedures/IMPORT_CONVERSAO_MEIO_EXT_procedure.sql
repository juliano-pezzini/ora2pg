-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_conversao_meio_ext ( nm_integracao_p text, nm_tabela_p text, nm_atributo_p text, cd_interno_p text, cd_externo_p text, ie_envio_receb_p text, cd_sistema_codificacao_p text, ie_update_p text, nm_usuario_p text, nr_linha_p bigint default 0) AS $body$
DECLARE



nr_sequencia_w 					conversao_meio_externo.nr_sequencia%type;
cd_externo_old_w				conversao_meio_externo.cd_externo%type;
ie_sistema_externo_old_w		conversao_meio_externo.ie_sistema_externo%type;
ie_envio_receb_old_w			conversao_meio_externo.ie_envio_receb%type;
cd_sistema_codificacao_old_w	conversao_meio_externo.cd_sistema_codificacao%type;
ds_motivo_w                     w_result_import_conversao.ds_motivo%type;
	

BEGIN

	if (cd_interno_p IS NOT NULL AND cd_interno_p::text <> '' AND cd_externo_p IS NOT NULL AND cd_externo_p::text <> '') then
	begin
		begin
	
		select	max(a.nr_sequencia),
				max(a.cd_externo),
				max(a.ie_envio_receb),
				max(a.cd_sistema_codificacao)
		into STRICT	nr_sequencia_w,
				cd_externo_old_w,
				ie_envio_receb_old_w,
				cd_sistema_codificacao_old_w
        from	conversao_meio_externo a
		where	a.ie_sistema_externo = nm_integracao_p
		and		a.nm_tabela = nm_tabela_p
		and		a.nm_atributo = nm_atributo_p
		and		a.cd_interno = cd_interno_p;

		EXCEPTION
		WHEN OTHERS THEN
            ds_motivo_w := SQLERRM;
			CALL insert_result_import_conv_ext(
						cd_interno_p, cd_externo_p,
						cd_externo_old_w, nm_usuario_p, nm_tabela_p,
						nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
						ie_envio_receb_old_w, cd_sistema_codificacao_p,
						cd_sistema_codificacao_old_w, 'R', ds_motivo_w,
                        nr_linha_p
                        );
		end;
	
		if (coalesce(nr_sequencia_w::text, '') = '') then
			begin
			
				insert into conversao_meio_externo(
						nr_sequencia,
						nm_usuario,
						dt_atualizacao,
						ie_sistema_externo,
						nm_tabela,
						nm_atributo,
						cd_interno,
						cd_externo,
						ie_envio_receb,
						cd_sistema_codificacao)
				values (nextval('conversao_meio_externo_seq'),
						nm_usuario_p,
						ESTABLISHMENT_TIMEZONE_UTILS.getCurrentDate,
						nm_integracao_p,
						nm_tabela_p,
						nm_atributo_p,
						cd_interno_p,
						cd_externo_p,
						ie_envio_receb_p,
						cd_sistema_codificacao_p);
					
				CALL insert_result_import_conv_ext(
						cd_interno_p, cd_externo_p,
						cd_externo_old_w, nm_usuario_p, nm_tabela_p,
						nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
						ie_envio_receb_old_w, cd_sistema_codificacao_p,
						cd_sistema_codificacao_old_w, 'I', null,
                        nr_linha_p
                        );
				
				EXCEPTION
				WHEN OTHERS THEN
				ds_motivo_w := SQLERRM;
				CALL insert_result_import_conv_ext(
						cd_interno_p, cd_externo_p,
						cd_externo_old_w, nm_usuario_p, nm_tabela_p,
						nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
						ie_envio_receb_old_w, cd_sistema_codificacao_p,
						cd_sistema_codificacao_old_w, 'R', ds_motivo_w,
                        nr_linha_p
                        );
				
			end;
		
		else
			if (ie_update_p = 'S') then
				
				begin
				
					update	conversao_meio_externo
					set		cd_externo = cd_externo_p,
							cd_interno = cd_interno_p,
							ie_envio_receb = ie_envio_receb_p,
							cd_sistema_codificacao = cd_sistema_codificacao_p,
							dt_atualizacao = ESTABLISHMENT_TIMEZONE_UTILS.getCurrentDate,
							nm_usuario = nm_usuario_p
					where 	nr_sequencia = nr_sequencia_w;
				
					CALL insert_result_import_conv_ext(
						cd_interno_p, cd_externo_p,
						cd_externo_old_w, nm_usuario_p, nm_tabela_p,
						nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
						ie_envio_receb_old_w, cd_sistema_codificacao_p,
						cd_sistema_codificacao_old_w, 'U', ds_motivo_w,
                        nr_linha_p
                        );
				EXCEPTION
				WHEN OTHERS THEN	
					ds_motivo_w := SQLERRM;
					CALL insert_result_import_conv_ext(
						cd_interno_p, cd_externo_p,
						cd_externo_old_w, nm_usuario_p, nm_tabela_p,
						nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
						ie_envio_receb_old_w, cd_sistema_codificacao_p,
						cd_sistema_codificacao_old_w, 'R', ds_motivo_w,
                        nr_linha_p
                        );
				end;
            else

                ds_motivo_w := obter_desc_expressao(1063280);
                CALL insert_result_import_conv_ext(
						cd_interno_p, cd_externo_p,
						cd_externo_old_w, nm_usuario_p, nm_tabela_p,
						nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
						ie_envio_receb_old_w, cd_sistema_codificacao_p,
						cd_sistema_codificacao_old_w, 'R', ds_motivo_w,
                        nr_linha_p
                        );

			end if;
		
		end if;
	end;

    else
    
        if (coalesce(cd_interno_p::text, '') = '') then
            ds_motivo_w := obter_desc_expressao(1063276);
        elsif (coalesce(cd_externo_p::text, '') = '') then
            ds_motivo_w := obter_desc_expressao(1063278);
        end if;
        CALL insert_result_import_conv_ext(
                    cd_interno_p, cd_externo_p,
                    cd_externo_old_w, nm_usuario_p, nm_tabela_p,
                    nm_atributo_p, nm_integracao_p, ie_envio_receb_p,
                    ie_envio_receb_old_w, cd_sistema_codificacao_p,
                    cd_sistema_codificacao_old_w, 'R', ds_motivo_w,
                    nr_linha_p
                    );
	end if;

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_conversao_meio_ext ( nm_integracao_p text, nm_tabela_p text, nm_atributo_p text, cd_interno_p text, cd_externo_p text, ie_envio_receb_p text, cd_sistema_codificacao_p text, ie_update_p text, nm_usuario_p text, nr_linha_p bigint default 0) FROM PUBLIC;
