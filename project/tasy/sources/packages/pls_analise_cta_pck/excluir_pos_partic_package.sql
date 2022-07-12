-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_analise_cta_pck.excluir_pos_partic ( nr_seq_conta_pos_estab_part_p pls_conta_pos_estab_partic.nr_sequencia%type, ie_excluir_proc_partic_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Exclui o participante do p?s estabelecido, e se solicitado o do procedimento tamb?m
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X]  Objetos do dicion?rio [X] Tasy (Delphi/Java) [ X] Portal [ X]  Relat?rios [ ] Outros:
------------------------------------------------------------------------------------------------------------------

Pontos de aten?ao:

      atualmente s? ? permitido excluir o participante do procedimento caso o mesmo
      foi inserido atrav?s de um p?s manual, ou seja, se ele ? originario de um participante
      de p?s incluido diretamente na analise.

Altera?oes:

------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ie_status_proc_part_w pls_proc_participante.ie_status%type;
ie_incluido_pos_estab_w pls_proc_participante.ie_incluido_pos_estab%type;
ie_alterado_pos_w pls_conta_pos_estab_partic.ie_alterado_pos%type;
nr_seq_proc_partic_w  pls_proc_participante.nr_sequencia%type;


BEGIN

-- so executa se foi informado o participante

if (nr_seq_conta_pos_estab_part_p IS NOT NULL AND nr_seq_conta_pos_estab_part_p::text <> '') then

  -- se for para excluir o participante do proc, deve validar se o p?s foi inserido manualmente,

  -- e se os status do partic proc estao condizentes

  if (coalesce(ie_excluir_proc_partic_p, 'N') = 'S') then

    select  max(b.ie_status),
      max(b.ie_incluido_pos_estab),
      max(a.ie_alterado_pos),
      max(b.nr_sequencia)
    into STRICT  ie_status_proc_part_w,
      ie_incluido_pos_estab_w,
      ie_alterado_pos_w,
      nr_seq_proc_partic_w
    from  pls_conta_pos_estab_partic  a,
      pls_proc_participante   b
    where b.nr_sequencia  = a.nr_seq_proc_partic
    and a.nr_sequencia  = nr_seq_conta_pos_estab_part_p;

    -- somente se for de origem de pos e com status C pode excluir

    if  not ((ie_status_proc_part_w = 'C') and (ie_incluido_pos_estab_w = 'S') and (ie_alterado_pos_w = 'S')) then
      CALL wheb_mensagem_pck.exibir_mensagem_abort(1064905);

    end if;

    
  end if;

  -- exclui o participante P?S

  delete from pls_conta_pos_estab_partic where nr_sequencia = nr_seq_conta_pos_estab_part_p;

  -- se chegou ate aqui com o parametro S, entao pode excluir se existir

  if (coalesce(ie_excluir_proc_partic_p, 'N') = 'S') then
    
    -- se for para excluir o 

    delete from pls_proc_participante where nr_sequencia = nr_seq_proc_partic_w;
  end if;

end if; -- fim se informado o participante

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_cta_pck.excluir_pos_partic ( nr_seq_conta_pos_estab_part_p pls_conta_pos_estab_partic.nr_sequencia%type, ie_excluir_proc_partic_p text) FROM PUBLIC;
