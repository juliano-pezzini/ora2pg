-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_dat_gen_rep_ins_account ( nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_opcao_p text) AS $body$
DECLARE


log_geracao_relat_conv_w        bigint;


BEGIN

        if (ie_opcao_p = 'I') then

                begin
                select  count(*)
                into STRICT    log_geracao_relat_conv_w
                from    log_geracao_relat_conv
                where   nr_atendimento = nr_atendimento_p
                and     nr_interno_conta = nr_interno_conta_p
                and     cd_estabelecimento = cd_estabelecimento_p
                and     cd_convenio = cd_convenio_p
                and     ie_tipo_log = 'E';
                exception
                when others then
                        log_geracao_relat_conv_w := 0;
                end;

                if (log_geracao_relat_conv_w = 0) then

                        begin
                        update  conta_paciente
                        set     dt_geracao_rel_conv = clock_timestamp()
                        where   coalesce(dt_geracao_rel_conv::text, '') = ''
                        and     cd_convenio_parametro = cd_convenio_p
                        and     cd_estabelecimento = cd_estabelecimento_p
                        and     nr_interno_conta = nr_interno_conta_p
                        and     nr_atendimento = nr_atendimento_p;
                        commit;
                        end;

                end if;

        elsif (ie_opcao_p = 'R') then

                begin
                update  conta_paciente
                set     dt_geracao_rel_conv  = NULL
                where   (dt_geracao_rel_conv IS NOT NULL AND dt_geracao_rel_conv::text <> '')
                and     cd_convenio_parametro = cd_convenio_p
                and     cd_estabelecimento = cd_estabelecimento_p
                and     nr_interno_conta = nr_interno_conta_p
                and     nr_atendimento = nr_atendimento_p;
                commit;
                end;

        end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_dat_gen_rep_ins_account ( nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_opcao_p text) FROM PUBLIC;
