-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gen_tent_reservation_icon (nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


        dt_start_reservation_w  timestamp;
        ds_alerta_w	        varchar(255);
        cd_unidade_basica_w     varchar(50);
        cd_exp_titulo_w         bigint;


BEGIN
        select  max(b.dt_start_reservation),
                max(b.cd_unidade_basica)
        into STRICT    dt_start_reservation_w,
                cd_unidade_basica_w
	from    unidade_atendimento b
	where	b.nr_atendimento = nr_atendimento_p;

        select  max(cd_exp_titulo)
        into STRICT    cd_exp_titulo_w
        from    w_pan_ocorrencia
        where   cd_exp_titulo = 1057957;

        ds_alerta_w := substr('<br>'|| '#@795070#@' ||': '||cd_unidade_basica_w,1,4000);

        if (obtain_user_locale(nm_usuario_p) = 'ja_JP') then
                        if ((dt_start_reservation_w IS NOT NULL AND dt_start_reservation_w::text <> '') and (coalesce(cd_exp_titulo_w::text, '') = '')) then
                                insert into w_pan_ocorrencia(nr_atendimento,
                                                cd_perfil,
                                                ie_icone,
                                                ds_imagem_padrao,
                                                ds_imagem_hover,
                                                cd_exp_titulo,
                                                nr_seq_texto_titulo,
                                                cd_exp_acao,
                                                nr_seq_texto_acao,
                                                ds_ocorrencia,
                                                nr_seq_apres,
                                                ie_concluido)
                                        values (nr_atendimento_p,
                                                null,
                                                60,
                                                'assets/icons/status-and-feedback/dashed-circle.svg',
                                                'assets/icons/status-and-feedback/dashed-circle.svg',
                                                1057957,
                                                1173435,
                                                null,
                                                null,
                                                ds_alerta_w,
                                                60,
                                                'S');
                        elsif (coalesce(dt_start_reservation_w::text, '') = '') then
                                delete from w_pan_ocorrencia
                                where   nr_atendimento = nr_atendimento_p
                                and     cd_exp_titulo = 1057957;
                        end if;
        end if;

        commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gen_tent_reservation_icon (nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

