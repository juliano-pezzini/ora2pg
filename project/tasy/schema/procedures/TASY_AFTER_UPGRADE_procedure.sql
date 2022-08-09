-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_after_upgrade () AS $body$
DECLARE

  v_nr_seq bigint;
  ds_erro_w varchar(2000);

BEGIN

  --##########################################################################
  -- Processo de atualizacao da tabela objeto_sistema_param para o novo modelo
  --##########################################################################
/*  begin
    select nvl(max(nr_sequencia), 0)
      into v_nr_seq
      from objeto_sistema_param
     where nr_seq_objeto = 2563;
  
    if v_nr_seq != 2563002 then
      delete objeto_sistema_param;
    end if;
  
    merge into objeto_sistema_param d
    using (select cast((case
                         when b.nr_sequencia > 10000000 then
                          (b.nr_sequencia - 10000000) + 1000000
                         else
                          b.nr_sequencia
                       end) * 1000 + a.sequence as number(10)) nr_sequencia,
                  b.dt_atualizacao dt_atualizacao_nrec,
                  cast(b.nm_usuario as varchar2(15)) nm_usuario_nrec,
                  b.dt_atualizacao dt_atualizacao,
                  cast(b.nm_usuario as varchar2(15)) nm_usuario,
                  cast(b.nr_sequencia as number(10)) nr_seq_objeto,
                  cast(a.argument_name as varchar2(30)) nm_parametro,
                  cast(a.in_out as varchar2(15)) ie_tipo_parametro,
                  cast(a.data_type as varchar2(15)) ie_tipo_dado_param,
                  cast(null as varchar2(15)) vl_default,
                  cast(a.position as number(10)) nr_seq_apresentacao
             from user_arguments a, user_objects c, objeto_sistema b
            where a.object_id = c.object_id
              and c.object_name = b.nm_objeto
              and c.object_type in ('PROCEDURE', 'FUNCTION')
              and a.package_name is null
              and a.argument_name is not null
              and (a.in_out, a.position) not in (('OUT', 0))) o
    on (d.nr_sequencia = o.nr_sequencia and d.nr_seq_objeto = o.nr_seq_objeto and d.nm_parametro = o.nm_parametro)
    when matched then
      update
         set d.dt_atualizacao_nrec = o.dt_atualizacao_nrec,
             d.nm_usuario_nrec     = o.nm_usuario_nrec,
             d.dt_atualizacao      = o.dt_atualizacao,
             d.nm_usuario          = o.nm_usuario,
             d.ie_tipo_parametro   = o.ie_tipo_parametro,
             d.ie_tipo_dado_param  = o.ie_tipo_dado_param,
             d.nr_seq_apresentacao = o.nr_seq_apresentacao
    when not matched then
      insert
        (d.nr_sequencia,
         d.dt_atualizacao_nrec,
         d.nm_usuario_nrec,
         d.dt_atualizacao,
         d.nm_usuario,
         d.nr_seq_objeto,
         d.nm_parametro,
         d.ie_tipo_parametro,
         d.ie_tipo_dado_param,
         d.vl_default,
         d.nr_seq_apresentacao)
      values
        (o.nr_sequencia,
         o.dt_atualizacao_nrec,
         o.nm_usuario_nrec,
         o.dt_atualizacao,
         o.nm_usuario,
         o.nr_seq_objeto,
         o.nm_parametro,
         o.ie_tipo_parametro,
         o.ie_tipo_dado_param,
         o.vl_default,
         o.nr_seq_apresentacao);
    commit;
  exception
    when others then
     ds_erro_w := substr(SQLERRM,1,2000);
      insert into log_atualizacao_erro
      values
        (log_atualizacao_erro_seq.nextval,
         'Error at proc Tasy_After_Update',
         ds_erro_w,
         174,
         SYSDATE,
         'Tasy_Versao');
         commit;
  end;
*/
  --#############################################
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_after_upgrade () FROM PUBLIC;
