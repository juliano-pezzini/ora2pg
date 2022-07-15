-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_cobr_sicredi_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) AS $body$
DECLARE


subtype nr_seq_reg_size is bigint;

vl_acrescimo_w				titulo_receber_cobr.vl_acrescimo%type;
vl_desconto_w				titulo_receber_cobr.vl_desconto%type;
vl_liquido_w				titulo_receber_cobr.vl_liquidacao%type;
vl_outras_despesas_w		titulo_receber_cobr.vl_despesa_bancaria%type;
vl_saldo_inclusao_w			titulo_receber.vl_saldo_titulo%type;
vl_abatimento_w				titulo_receber_cobr.vl_desconto%type;
dt_liquidacao_w				titulo_receber_cobr.dt_liquidacao%type;
nr_seq_ocorrencia_ret_w		banco_ocorr_escrit_ret.nr_sequencia%type;
nr_seq_arquivo_w			cobranca_escritural.nr_seq_arquivo%type;
cd_banco_w					cobranca_escritural.cd_banco%type;
nr_seq_reg_U_w				nr_seq_reg_size;
cont_w						nr_seq_reg_size;
ds_lista_titulos_w			varchar(4000);

c01 CURSOR FOR
	SELECT	nr_sequencia nr_seq_reg_T,
		(trim(both substr(ds_string,106,25)))::numeric  nr_titulo,
		(trim(both substr(ds_string,82,15)))::numeric /100 vl_titulo,
		trim(both substr(ds_string,16,2)) cd_ocorrencia_ret
	from	w_retorno_banco
	where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
	and	substr(ds_string,8,1)	= '3'
	and	substr(ds_string,14,1)	= 'T';

BEGIN

  begin

    select cd_banco
    into STRICT cd_banco_w 
    from cobranca_escritural 
    where nr_sequencia = nr_seq_cobr_escrit_p;

  exception
    when no_data_found then raise;
    when too_many_rows then raise;
  end;

  <<reg_segmentos_w>>
  for reg_segmentos_w in c01
  loop

    select 
      case when exists (select nr_titulo from titulo_receber where nr_titulo = reg_segmentos_w.nr_titulo) 
        then 1 else 0 
      end
    into STRICT cont_w;

    if (cont_w = 0) and (length(ds_lista_titulos_w) <= 3990) then
  
      if (coalesce(ds_lista_titulos_w::text, '') = '') then
        ds_lista_titulos_w	:= reg_segmentos_w.nr_titulo;
      else
        ds_lista_titulos_w	:= ds_lista_titulos_w || ', ' || reg_segmentos_w.nr_titulo;
      end if;

    elsif (reg_segmentos_w.cd_ocorrencia_ret in ('02','06','09','17','23','25','28','AA','AB')) then
  
      nr_seq_reg_U_w := reg_segmentos_w.nr_seq_reg_T + 1;

      select	(substr(ds_string,18,15))::numeric /100,
        (substr(ds_string,33,15))::numeric /100,
        (substr(ds_string,48,15))::numeric /100,
        (substr(ds_string,93,15))::numeric /100,
        (substr(ds_string,108,15))::numeric /100,
        to_date(CASE WHEN substr(ds_string,146,8)='        ' THEN null WHEN substr(ds_string,146,8)='00000000' THEN null  ELSE substr(ds_string,146,8) END ,'ddmmyyyy')
      into STRICT	vl_acrescimo_w,
        vl_desconto_w,
        vl_abatimento_w,
        vl_liquido_w,
        vl_outras_despesas_w,
        dt_liquidacao_w
      from	w_retorno_banco
      where	nr_sequencia	= nr_seq_reg_U_w;

      if (vl_acrescimo_w <= 0) then
        vl_acrescimo_w	:= vl_liquido_w - reg_segmentos_w.vl_titulo;
      end if;

      select 	max(a.nr_sequencia)
      into STRICT	nr_seq_ocorrencia_ret_w
      from	banco_ocorr_escrit_ret a
      where	a.cd_banco = cd_banco_w
      and	a.cd_ocorrencia = reg_segmentos_w.cd_ocorrencia_ret;

      select	coalesce(max(vl_saldo_titulo),0)
      into STRICT	vl_saldo_inclusao_w
      from	titulo_receber
      where	nr_titulo	= reg_segmentos_w.nr_titulo;

      if (cont_w > 0) then
        insert	into titulo_receber_cobr(	nr_sequencia,
            nr_titulo,
            cd_banco,
            vl_cobranca,
            vl_desconto,
            vl_acrescimo,
            vl_despesa_bancaria,
            vl_liquidacao,
            vl_saldo_inclusao,
            dt_liquidacao,
            dt_atualizacao,
            nm_usuario,
            nr_seq_cobranca,
            nr_seq_ocorrencia_ret)
        values (	nextval('titulo_receber_cobr_seq'),
            reg_segmentos_w.nr_titulo,
            cd_banco_w,
            reg_segmentos_w.vl_titulo,
            vl_desconto_w,
            vl_acrescimo_w,
            vl_outras_despesas_w,
            vl_liquido_w,
            vl_saldo_inclusao_w,
            dt_liquidacao_w,
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_cobr_escrit_p,
            nr_seq_ocorrencia_ret_w);

        /*Segundo o layout, caso o Codigo de Movimento para o retorno seja 02, trata-se de Entrada Confirmada. Nesses casos, atualizar o titulo_receber*/

        if (reg_segmentos_w.cd_ocorrencia_ret = '02') then
          update	titulo_receber a
          set	a.ie_entrada_confirmada = 'C'
          where	a.nr_titulo = reg_segmentos_w.nr_titulo;
        end if;

      else
        insert into cobranca_escrit_log(nr_sequencia,
          nm_usuario,
          dt_atualizacao,
          nm_usuario_nrec,
          dt_atualizacao_nrec,
          nr_seq_cobranca,
          ds_log)
        values (nextval('cobranca_escrit_log_seq'),
          nm_usuario_p,
          clock_timestamp(),
          nm_usuario_p,
          clock_timestamp(),
          nr_seq_cobr_escrit_p,
          'Nao foi importado o titulo ' || reg_segmentos_w.nr_titulo || ', pois nao foi encontrado no Tasy');
      end if;
    end if;

	end loop reg_segmentos_w;

  begin
  
    select	(substr(ds_string,158,6))::numeric  nr_seq_arquivo
    into STRICT	nr_seq_arquivo_w
    from	w_retorno_banco
    where	nr_seq_cobr_escrit	= nr_seq_cobr_escrit_p
    and	(substr(ds_string,1,3))::numeric  = cd_banco_w
    and	substr(ds_string,8,1)	= '0';

  exception
    when no_data_found then raise;
    when too_many_rows then raise;
  end;

  if (nr_seq_arquivo_w IS NOT NULL AND nr_seq_arquivo_w::text <> '') then
    update	cobranca_escritural
    set	nr_seq_arquivo	= nr_seq_arquivo_w
    where	nr_sequencia	= nr_seq_cobr_escrit_p;
  end if;

  commit;

  if (ds_lista_titulos_w IS NOT NULL AND ds_lista_titulos_w::text <> '') then
    CALL Wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => 186814, vl_macros_p => 'DS_LISTA_TITULOS='||ds_lista_titulos_w);
  end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_cobr_sicredi_240 ( nr_seq_cobr_escrit_p bigint, nm_usuario_p text) FROM PUBLIC;

