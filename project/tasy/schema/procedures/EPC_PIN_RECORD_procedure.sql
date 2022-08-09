-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE epc_pin_record (nr_sequencia_p bigint, nr_atendimento_p bigint, nm_tabela_p text, nm_usuario_p text, ie_fixar_p text DEFAULT 'N') AS $body$
DECLARE

  nr_seq_remove_w bigint := null;

BEGIN 
  
    if (ie_fixar_p = 'S') then
    
      insert into EPC_PINNED_RECORDS(NR_SEQUENCIA, NM_TABELA, NM_USUARIO, NR_ATENDIMENTO)
      values (nr_sequencia_p, nm_tabela_p, nm_usuario_p, nr_atendimento_p);

    end if;

    if (ie_fixar_p = 'N') then
    
      select max(nr_sequencia)
        into STRICT nr_seq_remove_w
      from EPC_PINNED_RECORDS
      where nr_sequencia = nr_sequencia_p
      and nr_atendimento = nr_atendimento_p
      and nm_tabela = nm_tabela_p
      and nm_usuario = nm_usuario_p;

      if (nr_seq_remove_w IS NOT NULL AND nr_seq_remove_w::text <> '') then
      
        delete from EPC_PINNED_RECORDS
        where nr_sequencia = nr_sequencia_p
        and nr_atendimento = nr_atendimento_p
        and nm_tabela = nm_tabela_p
        and nm_usuario = nm_usuario_p;

      end if;

    end if;
    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE epc_pin_record (nr_sequencia_p bigint, nr_atendimento_p bigint, nm_tabela_p text, nm_usuario_p text, ie_fixar_p text DEFAULT 'N') FROM PUBLIC;
