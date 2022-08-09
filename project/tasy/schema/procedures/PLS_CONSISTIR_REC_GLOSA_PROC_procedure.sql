-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_rec_glosa_proc ( nr_seq_conta_imp_p bigint, nm_usuario_p text, ds_msg_abort_p INOUT text, ie_consid_negados_p pls_parametros_rec_glosa.ie_consid_negado%type default null) AS $body$
DECLARE


nr_seq_conta_proc_w    pls_conta_proc.nr_sequencia%type;
vl_glosa_w      pls_conta_proc.vl_glosa%type;
vl_recursado_w      pls_rec_glosa_proc.vl_recursado%type;
ds_observacao_w      pls_rec_retorno_glosa.ds_observacao%type;

C01 CURSOR FOR
  SELECT   b.nr_sequencia,
    b.nr_seq_conta_proc,
    b.vl_recursado
  from   pls_rec_glosa_proc_imp b
  where   b.nr_seq_conta_imp = nr_seq_conta_imp_p;

BEGIN

for rg01 in C01 loop

  if (rg01.vl_recursado <= 0) then
    ds_msg_abort_p := 'Valor recursado indevido. O valor recursado deve ser maior que zero. Valor recursado: ' || rg01.vl_recursado || '.';

  elsif (coalesce(rg01.nr_seq_conta_proc::text, '') = ''  ) then
    CALL pls_gravar_glosa_recurso_glosa(  '1801', nr_seq_conta_imp_p, rg01.nr_sequencia, null, null, null, nm_usuario_p);

  elsif ( rg01.nr_seq_conta_proc is not  null ) then

    vl_recursado_w := pls_obter_saldo_recurso_glosa(rg01.nr_seq_conta_proc, 'P', 'R', ie_consid_negados_p);

    select  coalesce(sum(vl_glosa),0)
    into STRICT  vl_glosa_w
    from  pls_conta_proc
    where  nr_sequencia = rg01.nr_seq_conta_proc;
	
    if ( vl_glosa_w < vl_recursado_w) then

      vl_recursado_w := vl_recursado_w - rg01.vl_recursado;
      if (vl_glosa_w  <= vl_recursado_w) then

        CALL pls_gravar_glosa_recurso_glosa(  '2904', nr_seq_conta_imp_p, rg01.nr_sequencia, null, null, ds_observacao_w, nm_usuario_p);

      else
	
        ds_observacao_w :=   'Valor total recursado maior que o valor de glosa do item.' || pls_util_pck.enter_w ||
              'Valor recursado: ' || vl_recursado_w || pls_util_pck.enter_w ||
              'Valor recursando: ' || rg01.vl_recursado || pls_util_pck.enter_w ||
              'Valor glosa do item: ' || vl_glosa_w || '.';

        CALL pls_gravar_glosa_recurso_glosa(  '1705', nr_seq_conta_imp_p, rg01.nr_sequencia, null, null, ds_observacao_w, nm_usuario_p);
      end if;

    end if;
  end if;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_rec_glosa_proc ( nr_seq_conta_imp_p bigint, nm_usuario_p text, ds_msg_abort_p INOUT text, ie_consid_negados_p pls_parametros_rec_glosa.ie_consid_negado%type default null) FROM PUBLIC;
