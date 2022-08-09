-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_excluir_item_ccb (nr_sequencia_p bigint, nm_usuario_p text, ie_tipo_item_p text, nr_seq_analise_impacto_p bigint, ie_tipo_acao_p text) AS $body$
DECLARE


  -- ie_tipo_acao_p: (E) Excluir, (D) Desfazer Exclusao
  -- ie_tipo_item_p: (F) Funcao, (E) Escopo, (L) Localizacao
  ie_status_ccb_w   varchar(5);
  ie_tipo_impacto_w man_ordem_serv_impacto.ie_tipo_impacto%type;


BEGIN

  select ie_tipo_impacto
    into STRICT ie_tipo_impacto_w
    from man_ordem_serv_impacto
   where nr_sequencia = nr_seq_analise_impacto_p;

  if (ie_tipo_impacto_w = 'PRS') then

    if (ie_tipo_acao_p = 'E' and ie_tipo_item_p = 'F') then
    
      select max(ie_status_ccb)
        into STRICT ie_status_ccb_w
        from reg_funcao_pr
       where nr_sequencia = nr_sequencia_p;

      if (coalesce(ie_status_ccb_w::text, '') = '' or ie_status_ccb_w = 'A') then
      
        -- Atualiza para o status AE (Aguardando Exclusao)
        update reg_funcao_pr
           set ie_status_ccb          = 'AE',
               nm_usuario             = nm_usuario_p,
               dt_atualizacao         = clock_timestamp(),
               nr_seq_analise_impacto = nr_seq_analise_impacto_p
         where nr_sequencia = nr_sequencia_p;

      elsif (ie_status_ccb_w = 'AI') then
      
        delete from reg_funcao_pr where nr_sequencia = nr_sequencia_p;

      end if;

    elsif (ie_tipo_acao_p = 'E' and ie_tipo_item_p = 'E') then
    
      select max(ie_status_ccb)
        into STRICT ie_status_ccb_w
        from reg_escopo_product_req
       where nr_sequencia = nr_sequencia_p;

      if (coalesce(ie_status_ccb_w::text, '') = '' or ie_status_ccb_w = 'A') then
      
        -- Atualiza para o status AE (Aguardando Exclusao)
        update reg_escopo_product_req
           set ie_status_ccb          = 'AE',
               nm_usuario             = nm_usuario_p,
               dt_atualizacao         = clock_timestamp(),
               nr_seq_analise_impacto = nr_seq_analise_impacto_p
         where nr_sequencia = nr_sequencia_p;

      elsif (ie_status_ccb_w = 'AI') then
      
        delete from reg_escopo_product_req
         where nr_sequencia = nr_sequencia_p;

      end if;

    elsif (ie_tipo_acao_p = 'E' and ie_tipo_item_p = 'L') then
    
      select max(ie_status_ccb)
        into STRICT ie_status_ccb_w
        from reg_product_req_loc
       where nr_sequencia = nr_sequencia_p;

      if (coalesce(ie_status_ccb_w::text, '') = '' or ie_status_ccb_w = 'A') then
      
        -- Atualiza para o status AE (Aguardando Exclusao)
        update reg_product_req_loc
           set ie_status_ccb          = 'AE',
               nm_usuario             = nm_usuario_p,
               dt_atualizacao         = clock_timestamp(),
               nr_seq_analise_impacto = nr_seq_analise_impacto_p
         where nr_sequencia = nr_sequencia_p;

      elsif (ie_status_ccb_w = 'AI') then
      
        delete from reg_product_req_loc
         where nr_sequencia = nr_sequencia_p;

      end if;

    elsif (ie_tipo_acao_p = 'D' and ie_tipo_item_p = 'F') then
    
      update reg_funcao_pr
         set ie_status_ccb           = NULL,
             nm_usuario             = nm_usuario_p,
             dt_atualizacao         = clock_timestamp(),
             nr_seq_analise_impacto  = NULL
       where nr_sequencia = nr_sequencia_p;

    elsif (ie_tipo_acao_p = 'D' and ie_tipo_item_p = 'E') then
    
      update reg_escopo_product_req
         set ie_status_ccb           = NULL,
             nm_usuario             = nm_usuario_p,
             dt_atualizacao         = clock_timestamp(),
             nr_seq_analise_impacto  = NULL
       where nr_sequencia = nr_sequencia_p;

    elsif (ie_tipo_acao_p = 'D' and ie_tipo_item_p = 'L') then
    
      update reg_product_req_loc
         set ie_status_ccb           = NULL,
             nm_usuario             = nm_usuario_p,
             dt_atualizacao         = clock_timestamp(),
             nr_seq_analise_impacto  = NULL
       where nr_sequencia = nr_sequencia_p;

    end if;

  elsif (ie_tipo_impacto_w = 'URS') then
  
    if (ie_tipo_acao_p = 'E' and ie_tipo_item_p = 'E') then
    
      select max(ie_status_ccb)
        into STRICT ie_status_ccb_w
        from reg_escopo_customer_req
       where nr_sequencia = nr_sequencia_p;

      if (coalesce(ie_status_ccb_w::text, '') = '' or ie_status_ccb_w = 'A') then
      
        -- Atualiza para o status AE (Aguardando Exclusao)
        update reg_escopo_customer_req
           set ie_status_ccb          = 'AE',
               nm_usuario             = nm_usuario_p,
               dt_atualizacao         = clock_timestamp(),
               nr_seq_analise_impacto = nr_seq_analise_impacto_p
         where nr_sequencia = nr_sequencia_p;

      elsif (ie_status_ccb_w = 'AI') then
      
        delete from reg_escopo_customer_req
         where nr_sequencia = nr_sequencia_p;

      end if;

    elsif (ie_tipo_acao_p = 'E' and ie_tipo_item_p = 'L') then
    
      select max(ie_status_ccb)
        into STRICT ie_status_ccb_w
        from reg_customer_req_loc
       where nr_sequencia = nr_sequencia_p;

      if (coalesce(ie_status_ccb_w::text, '') = '' or ie_status_ccb_w = 'A') then
      
        -- Atualiza para o status AE (Aguardando Exclusao)
        update reg_customer_req_loc
           set ie_status_ccb          = 'AE',
               nm_usuario             = nm_usuario_p,
               dt_atualizacao         = clock_timestamp(),
               nr_seq_analise_impacto = nr_seq_analise_impacto_p
         where nr_sequencia = nr_sequencia_p;

      elsif (ie_status_ccb_w = 'AI') then
      
        delete from reg_customer_req_loc
         where nr_sequencia = nr_sequencia_p;

      end if;

    elsif (ie_tipo_acao_p = 'D' and ie_tipo_item_p = 'E') then
    
      update reg_escopo_customer_req
         set ie_status_ccb           = NULL,
             nm_usuario             = nm_usuario_p,
             dt_atualizacao         = clock_timestamp(),
             nr_seq_analise_impacto  = NULL
       where nr_sequencia = nr_sequencia_p;

    elsif (ie_tipo_acao_p = 'D' and ie_tipo_item_p = 'L') then
    
      update reg_customer_req_loc
         set ie_status_ccb           = NULL,
             nm_usuario             = nm_usuario_p,
             dt_atualizacao         = clock_timestamp(),
             nr_seq_analise_impacto  = NULL
       where nr_sequencia = nr_sequencia_p;

    end if;

  end if;

  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_excluir_item_ccb (nr_sequencia_p bigint, nm_usuario_p text, ie_tipo_item_p text, nr_seq_analise_impacto_p bigint, ie_tipo_acao_p text) FROM PUBLIC;
