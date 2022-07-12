-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_online_pck.ctb_excluir_lancamento_doc (nr_seq_ctb_documento_p ctb_documento.nr_sequencia%type, nm_usuario_p text, ie_commit_p text default 'S') AS $body$
DECLARE


nr_seq_centro_custo_w    ctb_movto_centro_custo.nr_sequencia%type;
vl_movto_centro_custo_w  ctb_movto_centro_custo.vl_movimento%type;
qt_movto_contab_doc_w    bigint;
ie_removeu_w             varchar(1) := 'N';
ds_erro_w                varchar(4000);

c01 CURSOR FOR
SELECT a.nr_sequencia,
       a.nr_lote_contabil,
       a.vl_movimento vl_movto_doc,
       a.nr_seq_ctb_movto,
       a.cd_centro_custo,
       b.vl_movimento,
       b.dt_atualizacao_saldo dt_atualizacao_saldo_movto,
       c.dt_atualizacao dt_atualizacao_saldo_lote
from   movimento_contabil_doc a,
       ctb_movimento b,
       lote_contabil c
where  a.nr_seq_ctb_movto = b.nr_sequencia
and    b.nr_lote_contabil = c.nr_lote_contabil
and    a.nr_seq_ctb_documento = nr_seq_ctb_documento_p
and    ctb_obter_se_mes_fechado(c.nr_seq_mes_ref, c.cd_estabelecimento) = upper('A')
order by b.nr_seq_movto_partida;

c01_w c01%rowtype;

c02 CURSOR FOR
SELECT a.nr_sequencia,
       a.nr_lote_contabil
from   ctb_movimento a
where  a.nr_seq_movto_partida = c01_w.nr_seq_ctb_movto;

c02_w c02%rowtype;


BEGIN

open c01;
loop
fetch c01
    into c01_w;
    EXIT WHEN NOT FOUND; /* apply on c01 */
    begin
        ie_removeu_w := 'S';

        delete  FROM movimento_contabil_doc
        where   nr_sequencia = c01_w.nr_sequencia;

        if (c01_w.dt_atualizacao_saldo_movto IS NOT NULL AND c01_w.dt_atualizacao_saldo_movto::text <> '') then
            CALL ctb_online_pck.ctb_desatualizar_saldo_movto(c01_w.nr_seq_ctb_movto,'N',nm_usuario_p,'N');
        end if;

        if (coalesce(c01_w.cd_centro_custo,0) <> 0) then
           begin
           select nr_sequencia,
                  vl_movimento
           into STRICT   nr_seq_centro_custo_w,
                  vl_movto_centro_custo_w
           from   ctb_movto_centro_custo a
           where  a.cd_centro_custo  = c01_w.cd_centro_custo
           and    a.nr_seq_movimento = c01_w.nr_seq_ctb_movto;
           exception
                  when others then
                    nr_seq_centro_custo_w := null;
           end;

           if ((nr_seq_centro_custo_w IS NOT NULL AND nr_seq_centro_custo_w::text <> '') and vl_movto_centro_custo_w <> c01_w.vl_movto_doc) then
                begin
                    update  ctb_movto_centro_custo a
                    set     a.vl_movimento      = a.vl_movimento - c01_w.vl_movto_doc,
                            a.dt_atualizacao    = clock_timestamp(),
                            a.nm_usuario        = nm_usuario_p
                    where   a.nr_sequencia      = nr_seq_centro_custo_w;
                end;
           elsif ((nr_seq_centro_custo_w IS NOT NULL AND nr_seq_centro_custo_w::text <> '') and vl_movto_centro_custo_w = c01_w.vl_movto_doc) then
                begin
                    delete  FROM ctb_movto_centro_custo a
                    where   a.nr_sequencia = nr_seq_centro_custo_w;
                end;
           end if;

           CALL ctb_atualizar_rateio_movto(c01_w.nr_seq_ctb_movto,nm_usuario_p,'N');
        end if;

        select count(a.nr_sequencia)
        into STRICT   qt_movto_contab_doc_w
        from   movimento_contabil_doc a
        where  a.nr_seq_ctb_movto = c01_w.nr_seq_ctb_movto;

        if (qt_movto_contab_doc_w > 0) then
            begin
                update  ctb_movimento a
                set     a.vl_movimento      = a.vl_movimento - c01_w.vl_movto_doc,
                        a.dt_atualizacao    = clock_timestamp(),
                        a.nm_usuario        = nm_usuario_p
                where   a.nr_sequencia      = c01_w.nr_seq_ctb_movto;

                CALL ctb_online_pck.ctb_atualizar_saldo_movto(c01_w.nr_seq_ctb_movto, 'S', nm_usuario_p,'N');
            end;
        else
            begin
                for c02_w in c02 loop
                begin
                  ds_erro_p           => ds_erro_w := ctb_online_pck.ctb_excluir_lancamento(nr_seq_lancamento_p => null, nr_lote_contabil_p  => c02_w.nr_lote_contabil, nm_usuario_p        => nm_usuario_p, nr_seq_movimento_p  => c02_w.nr_sequencia, ie_commit_p         => 'N', ds_erro_p           => ds_erro_w);
                end;
                end loop;

                delete  FROM ctb_movimento
                where   nr_sequencia = c01_w.nr_seq_ctb_movto;
            end;
        end if;

    end;
end loop;
close C01;

if (upper(ie_removeu_w) = upper('S')) then
  update  ctb_documento
  set     ie_situacao_ctb     = current_setting('ctb_online_pck.ds_pendente')::varchar(1),
          nr_lote_contabil     = NULL
  where   nr_sequencia        = nr_seq_ctb_documento_p;

  if (ie_commit_p = 'S') then
      commit;
  end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_online_pck.ctb_excluir_lancamento_doc (nr_seq_ctb_documento_p ctb_documento.nr_sequencia%type, nm_usuario_p text, ie_commit_p text default 'S') FROM PUBLIC;
