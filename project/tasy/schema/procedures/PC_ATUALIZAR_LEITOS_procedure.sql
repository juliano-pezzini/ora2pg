-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pc_atualizar_leitos ( cd_departamento_p departamento_setor.cd_departamento%type, cd_setor_atendimento_p unidade_atendimento.cd_setor_atendimento%type, ie_status_leito_p unidade_atendimento.ie_status_unidade%type, nm_usuario_p usuario.nm_usuario%type default null) AS $body$
DECLARE

cd_estabelecimento_w    usuario.cd_estabelecimento%type;
hr_dif_atualizaco_w     bigint;
nr_segundos_minimos_w   bigint;

c_unidade_atendimento_w CURSOR FOR
SELECT      c.nr_seq_interno
from        departamento_setor a,
            setor_atendimento b,
            unidade_atendimento c
where       1 = 1
and         a.cd_departamento       = coalesce(cd_departamento_p, a.cd_departamento)
and         a.cd_setor_atendimento  = b.cd_setor_atendimento
and         b.cd_setor_atendimento  = coalesce(cd_setor_atendimento_p, b.cd_setor_atendimento)
and         c.cd_setor_atendimento  = b.cd_setor_atendimento
and         c.ie_status_unidade     = coalesce(ie_status_leito_p, b.ie_status_unidade)
and         obter_se_usuario_setor(nm_usuario_p, b.cd_setor_atendimento) = 'S'
and         b.ie_situacao = 'A'
order by    a.cd_setor_atendimento;

BEGIN

select  coalesce(obter_hora_entre_datas(dt_fim_atualizacao, clock_timestamp()), 0)
into STRICT    hr_dif_atualizaco_w
from    w_panorama
where   ie_concluido = 'S';

nr_segundos_minimos_w := 0.0083; -- 30 segundos
if (hr_dif_atualizaco_w > nr_segundos_minimos_w)then

    cd_estabelecimento_w    := obter_estab_usuario(nm_usuario_p);

    for unidade_atendimento_w in c_unidade_atendimento_w loop
        CALL panorama_leito_pck.atualizar_w_pan_leito(cd_estabelecimento_w, unidade_atendimento_w.nr_seq_interno, nm_usuario_p);
    end loop;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pc_atualizar_leitos ( cd_departamento_p departamento_setor.cd_departamento%type, cd_setor_atendimento_p unidade_atendimento.cd_setor_atendimento%type, ie_status_leito_p unidade_atendimento.ie_status_unidade%type, nm_usuario_p usuario.nm_usuario%type default null) FROM PUBLIC;

