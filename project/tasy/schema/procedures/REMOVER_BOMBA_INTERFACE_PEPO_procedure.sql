-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_bomba_interface_pepo (nr_sequencia_interface_p bomba_infusao_interface.nr_sequencia%type, nr_seq_bomba_infusao_p bomba_infusao.nr_sequencia%type) AS $body$
DECLARE

  existe_seq_agente_w bigint;


BEGIN

  begin
    CALL remover_bomba_interface(nr_sequencia_interface_p,
                            nr_seq_bomba_infusao_p,
                            'S');
  end;

  begin

    select count(1)
      into STRICT existe_seq_agente_w
      from bomba_infusao bi
     where bi.nr_seq_agente in (SELECT nr_seq_agente
              from bomba_infusao
             where nr_sequencia = nr_seq_bomba_infusao_p)
       and bi.nr_sequencia <> nr_seq_bomba_infusao_p
       and bi.ie_status <> 'DS';

    if existe_seq_agente_w = 0 then
    
      CALL registrar_solucao_pepo('FINALIZAR',
                             wheb_usuario_pck.get_nm_usuario,
                             nr_sequencia_interface_p,
                             nr_seq_bomba_infusao_p,
                             null);
    end if;

  end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_bomba_interface_pepo (nr_sequencia_interface_p bomba_infusao_interface.nr_sequencia%type, nr_seq_bomba_infusao_p bomba_infusao.nr_sequencia%type) FROM PUBLIC;
