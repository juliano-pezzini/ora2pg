-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION philips_management_pck.obter_calendario_recurso (ie_area_p text,dt_inicio_p timestamp, dt_fim_p timestamp, nm_recurso_p text) RETURNS T_ALOCACAO_TB AS $body$
DECLARE

        alocacao_tb_w t_alocacao_tb;

BEGIN
       
        EXECUTE obter_query_calendario 
        BULK COLLECT INTO STRICT alocacao_tb_w 
        USING   dt_inicio_p, 
                dt_inicio_p, 
                dt_fim_p, 
                dt_inicio_p,
                ie_area_p,
                ie_area_p,
                nm_recurso_p;

        return alocacao_tb_w;
    end;


    /*
        obter alocacao usuario somente percentual
        Retorno
            Area: Operacao
            -1 100% Alocado na operacao Azul
            1  100% Alocado em projetos da operacao Azul forte
            1+ Sobrealocado em projetos da operacao vermelho
            -5 Pessoa Ausente - Bloqueado
            
            Area: Projetos
            1  100% alocado projeto legenda: branco
            1+ Sobre alocado legenda: vermelho
            0  Disponivel legenda: verde
            -5 Pessoa Ausente - Bloqueado
    */
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION philips_management_pck.obter_calendario_recurso (ie_area_p text,dt_inicio_p timestamp, dt_fim_p timestamp, nm_recurso_p text) FROM PUBLIC;