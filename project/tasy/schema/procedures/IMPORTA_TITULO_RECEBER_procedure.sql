-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_titulo_receber ( NM_USUARIO_P text, IE_COMMIT_P text, IE_PERMITE_TITULO_EXTERNO_P text) AS $body$
DECLARE

c01 CURSOR FOR
       
	SELECT	ds_string
	from	w_retorno_banco
	where	nm_usuario = NM_USUARIO_P
    and ie_importacao_tit_rec = 'S'
    order by nr_sequencia asc;

c01_w				        c01%rowtype;
titulo_receber_w	        titulo_receber%rowtype;
numero_externo_duplicado_w  titulo_receber.nr_titulo_externo%type;
numero_ext_dup_pessoa_w     titulo_receber.nr_titulo_externo%type;
ds_inconsistencia_w	        varchar(4000);
ie_insere_titulo_w          char;
contador_w                  bigint;
qt_reg_w		bigint;
nr_cpf_w		varchar(15); -- OS 2056149, nao segue o padrao  titulo_receber_w pois nao existe o campo NR_CPF na tabela TITULO_RECEBER.
ds_msg_w		varchar(100);

BEGIN

contador_w := 0;

open c01;
    loop
        fetch c01 into	
            c01_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */

        begin

            contador_w := contador_w + 1;

            titulo_receber_w.nr_titulo_externo       := trim(both substr(c01_w.ds_string, 001, 010)); --varchar2
            titulo_receber_w.cd_estabelecimento      := (trim(both substr(c01_w.ds_string, 011, 005)))::numeric; --number
            titulo_receber_w.dt_emissao              := trim(both substr(c01_w.ds_string, 016, 008)); --date
            titulo_receber_w.dt_vencimento           := trim(both substr(c01_w.ds_string, 024, 008)); --date
            titulo_receber_w.dt_pagamento_previsto   := trim(both substr(c01_w.ds_string, 032, 008)); --date
            titulo_receber_w.vl_titulo               := (trim(both substr(c01_w.ds_string, 040, 015)))::numeric  / 100; --number
            titulo_receber_w.vl_saldo_titulo         := (trim(both substr(c01_w.ds_string, 055, 015)))::numeric  / 100; --number
            titulo_receber_w.vl_saldo_juros          := (trim(both substr(c01_w.ds_string, 070, 015)))::numeric  / 100; --number
            titulo_receber_w.vl_saldo_multa          := (trim(both substr(c01_w.ds_string, 085, 015)))::numeric  / 100; --number
            titulo_receber_w.cd_moeda                := (trim(both substr(c01_w.ds_string, 100, 005)))::numeric; --number
            titulo_receber_w.cd_portador             := (trim(both substr(c01_w.ds_string, 105, 010)))::numeric; --number
            titulo_receber_w.cd_tipo_portador        := (trim(both substr(c01_w.ds_string, 115, 005)))::numeric; --number
            titulo_receber_w.tx_juros                := (trim(both substr(c01_w.ds_string, 120, 007)))::numeric  / 10000; --number
            titulo_receber_w.tx_multa                := (trim(both substr(c01_w.ds_string, 127, 007)))::numeric  / 10000; --number
            titulo_receber_w.cd_tipo_taxa_juro       := (trim(both substr(c01_w.ds_string, 134, 010)))::numeric; --number
            titulo_receber_w.cd_tipo_taxa_multa      := (trim(both substr(c01_w.ds_string, 144, 010)))::numeric; --number
            titulo_receber_w.tx_desc_antecipacao     := (trim(both substr(c01_w.ds_string, 154, 007)))::numeric  / 10000; --number
            titulo_receber_w.ie_situacao             := trim(both substr(c01_w.ds_string, 161, 001)); --varchar2
            titulo_receber_w.ie_tipo_emissao_titulo  := (trim(both substr(c01_w.ds_string, 162, 005)))::numeric; --number
            titulo_receber_w.ie_origem_titulo        := trim(both substr(c01_w.ds_string, 167, 010)); --varchar2
            titulo_receber_w.ie_tipo_titulo          := trim(both substr(c01_w.ds_string, 177, 002)); --varchar2
            titulo_receber_w.ie_tipo_inclusao        := trim(both substr(c01_w.ds_string, 179, 001)); --varchar2
            titulo_receber_w.cd_pessoa_fisica        := trim(both substr(c01_w.ds_string, 180, 010)); --varchar2
            titulo_receber_w.cd_cgc                  := trim(both substr(c01_w.ds_string, 190, 014)); --varchar2
            titulo_receber_w.nr_documento            := (trim(both substr(c01_w.ds_string, 204, 012)))::numeric; --number
            titulo_receber_w.nr_bloqueto             := trim(both substr(c01_w.ds_string, 226, 044)); --varchar2
            titulo_receber_w.dt_liquidacao           := trim(both substr(c01_w.ds_string, 270, 008)); --date
            titulo_receber_w.ds_observacao_titulo    := trim(both substr(c01_w.ds_string, 278, 100)); --varchar2
            titulo_receber_w.dt_contabil             := trim(both substr(c01_w.ds_string, 378, 008)); --date
            titulo_receber_w.nr_seq_conta_banco      := (trim(both substr(c01_w.ds_string, 386, 010)))::numeric; --number
            titulo_receber_w.dt_emissao_bloqueto     := trim(both substr(c01_w.ds_string, 396, 008)); --date
            titulo_receber_w.nr_seq_classe           := (trim(both substr(c01_w.ds_string, 404, 010)))::numeric; --number
            titulo_receber_w.nr_nosso_numero         := trim(both substr(c01_w.ds_string, 414, 020)); --varchar2
            titulo_receber_w.cd_tipo_recebimento     := (trim(both substr(c01_w.ds_string, 434, 005)))::numeric; --number
            titulo_receber_w.nr_seq_trans_fin_contab := (trim(both substr(c01_w.ds_string, 439, 010)))::numeric; --number
            titulo_receber_w.vl_desc_previsto        := (trim(both substr(c01_w.ds_string, 449, 015)))::numeric  / 100; --number
            titulo_receber_w.nr_seq_carteira_cobr    := (trim(both substr(c01_w.ds_string, 464, 010)))::numeric; --number
            titulo_receber_w.cd_estab_financeiro     := (trim(both substr(c01_w.ds_string, 474, 005)))::numeric; --number
            titulo_receber_w.nr_seq_trans_fin_baixa  := (trim(both substr(c01_w.ds_string, 479, 010)))::numeric; --number
            titulo_receber_w.nr_nota_fiscal          := trim(both substr(c01_w.ds_string, 489, 012)); --varchar2
            titulo_receber_w.nm_usuario_orig         := trim(both substr(c01_w.ds_string, 501, 015)); --varchar2
            titulo_receber_w.dt_inclusao             := trim(both substr(c01_w.ds_string, 516, 008)); --date
            titulo_receber_w.vl_outras_despesas      := (trim(both substr(c01_w.ds_string, 524, 015)))::numeric; --number
            titulo_receber_w.nr_seq_tf_curto_prazo   := (trim(both substr(c01_w.ds_string, 539, 010)))::numeric; --number
            titulo_receber_w.dt_limite_desconto      := trim(both substr(c01_w.ds_string, 549, 008)); --date
            titulo_receber_w.vl_titulo_estrang       := (trim(both substr(c01_w.ds_string, 557, 015)))::numeric; --number
            titulo_receber_w.vl_cotacao              := (trim(both substr(c01_w.ds_string, 572, 019)))::numeric; --number
	    nr_cpf_w		                     := trim(both substr(c01_w.ds_string, 592, 15)); --varchar
            titulo_receber_w.dt_atualizacao          := clock_timestamp(); --date
            titulo_receber_w.nm_usuario              := NM_USUARIO_P; --varchar2
            begin

                if (titulo_receber_w.ie_situacao not in ('1', '2', '3', '4', '5', '6')) then
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(1097764,'ds_campo=' || 'ie_situacao' || ';nr_linha=' || contador_w || ';ds_dominio=' || '710');
                elsif (titulo_receber_w.ie_tipo_emissao_titulo not in ('1', '2', '3', '4', '5')) then
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(1097764,'ds_campo=' || 'ie_tipo_emissao_titulo' || ';nr_linha=' || contador_w || ';ds_dominio=' || '702');
                elsif (titulo_receber_w.ie_origem_titulo not in ('0', '1', '10', '11', '12', '13', '14', '14', '15', '16', '17', '18', '19', '2', '3', '4', '5', '6', '7', '8', '9')) then
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(1097764,'ds_campo=' || 'ie_origem_titulo' || ';nr_linha=' || contador_w || ';ds_dominio=' || '709');
                elsif (titulo_receber_w.ie_tipo_titulo not in ('1', '10', '11', '12', '13', '14', '14', '15', '16', '17', '18', '2', '3', '4', '5', '6', '7', '8', '9')) then
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(1097764,'ds_campo=' || 'ie_tipo_titulo' || ';nr_linha=' || contador_w || ';ds_dominio=' || '712');
                elsif (titulo_receber_w.ie_tipo_inclusao not in ('1', '2')) then
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(1097764,'ds_campo=' || 'ie_tipo_inclusao' || ';nr_linha=' || contador_w || ';ds_dominio=' || '713');
                end if;
		
		/*OS 2056149 - Buscar a pessoa fisica no tasy pelo codigo no sistema anterior e CPF*/

		if (titulo_receber_w.cd_pessoa_fisica IS NOT NULL AND titulo_receber_w.cd_pessoa_fisica::text <> '') then
			select 	count(*)
			into STRICT	qt_reg_w
			from	pessoa_fisica
			where   cd_pessoa_fisica = titulo_receber_w.cd_pessoa_fisica;
			
			if (qt_reg_w = 0) then --Se  nao encontrar pelo codigo, tentar localizar pelo codigo de sistema anterior
				select	count(*)
				into STRICT	qt_reg_w
				from	pessoa_fisica
				where	trim(both cd_sistema_ant) = trim(both titulo_receber_w.cd_pessoa_fisica);
				
				if (qt_reg_w = 0) then --Se  nao encontrar pelo codigo do sistema anterior, tenta localizar pelo numero do CPF
					select	count(*)
					into STRICT	qt_reg_w
					from	pessoa_fisica
					where	trim(both nr_cpf) = trim(both nr_cpf_w);
					
					if (qt_reg_w > 0) then
						select 	max(cd_pessoa_fisica)
						into STRICT	titulo_receber_w.cd_pessoa_fisica
						from	pessoa_fisica
						where	trim(both nr_cpf) = trim(both nr_cpf_w);
					elsif (qt_reg_w = 0) then
						if ((trim(both nr_cpf_w) IS NOT NULL AND (trim(both nr_cpf_w))::text <> '')) then
							ds_msg_w := substr(trim(both substr(c01_w.ds_string, 180, 010))||' / '||trim(both nr_cpf_w),1,100);
						else
							ds_msg_w := substr(trim(both substr(c01_w.ds_string, 180, 010)),1,100);
						end if;
						CALL wheb_mensagem_pck.exibir_mensagem_abort(263286,'CD_PESSOA_FISICA_P=' ||ds_msg_w);
					end if;
				elsif (qt_reg_w > 0) then
					select	max(cd_pessoa_fisica)
					into STRICT	titulo_receber_w.cd_pessoa_fisica
					from	pessoa_fisica 
					where	trim(both cd_sistema_ant) = trim(both titulo_receber_w.cd_pessoa_fisica);
				end if;
			end if;
			
			if (coalesce(titulo_receber_w.cd_pessoa_fisica::text, '') = '') then
				if ((trim(both nr_cpf_w) IS NOT NULL AND (trim(both nr_cpf_w))::text <> '')) then
					ds_msg_w := substr(trim(both substr(c01_w.ds_string, 180, 010))||' / '||trim(both nr_cpf_w),1,100);
				else
					ds_msg_w := substr(trim(both substr(c01_w.ds_string, 180, 010)),1,100);
				end if;
				CALL wheb_mensagem_pck.exibir_mensagem_abort(263286,'CD_PESSOA_FISICA_P=' ||ds_msg_w);
			end if;
			
		end if;
		/*OS 2056149 FIM*/

                ie_insere_titulo_w := 'N';

                if (titulo_receber_w.nr_titulo_externo IS NOT NULL AND titulo_receber_w.nr_titulo_externo::text <> '') then
                    select max(nr_titulo_externo)
                    into STRICT numero_externo_duplicado_w
                    from titulo_receber 
                    where nr_titulo_externo = titulo_receber_w.nr_titulo_externo;

                    if (coalesce(numero_externo_duplicado_w::text, '') = '') then
                        ie_insere_titulo_w := 'S';
                    elsif (upper(IE_PERMITE_TITULO_EXTERNO_P) = 'TRUE') or (upper(IE_PERMITE_TITULO_EXTERNO_P) = 'S') then
                        select max(tr.nr_titulo_externo)
                        into STRICT numero_ext_dup_pessoa_w
                        from titulo_receber tr
                        where tr.nr_titulo_externo = titulo_receber_w.nr_titulo_externo
                        and (tr.cd_pessoa_fisica = titulo_receber_w.cd_pessoa_fisica or tr.cd_cgc = titulo_receber_w.cd_cgc)
			and	tr.cd_estabelecimento	= titulo_receber_w.cd_estabelecimento
			and	tr.ie_origem_titulo	= titulo_receber_w.ie_origem_titulo
			and	tr.nr_nota_fiscal	= titulo_receber_w.nr_nota_fiscal;
			
                        if (coalesce(numero_ext_dup_pessoa_w::text, '') = '') then
                            ie_insere_titulo_w := 'S';
                        else
                            CALL wheb_mensagem_pck.exibir_mensagem_abort(1141858 ,'NR_LINHA=' || contador_w || ';NM_PESSOA=' || substr(obter_nome_pf_pj(titulo_receber_w.cd_pessoa_fisica, titulo_receber_w.cd_cgc),1,255));
                        end if;
                    else
                        CALL wheb_mensagem_pck.exibir_mensagem_abort(1097765 ,'NR_LINHA=' || contador_w);
                    end if;
                else
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(1097766 ,'NR_LINHA=' || contador_w);
                end if;

                if (ie_insere_titulo_w = 'S') then
                    select	nextval('titulo_seq')
                    into STRICT	titulo_receber_w.nr_titulo
;

                    insert into titulo_receber values (titulo_receber_w.*);

                    insert into titulo_receber_hist(ds_historico,
                                                    dt_historico,
                                                    nm_usuario,
                                                    nr_sequencia,
                                                    dt_atualizacao,
                                                    nr_titulo) 
                    values (wheb_mensagem_pck.get_texto(1141853, 'ie_permite_titulo_externo_p=' || numero_ext_dup_pessoa_w),
                            titulo_receber_w.dt_atualizacao,
                            titulo_receber_w.nm_usuario,
                            nextval('titulo_receber_hist_seq'),
                            titulo_receber_w.dt_atualizacao,
                            titulo_receber_w.nr_titulo);
                end if;
            end;

        end;

    end loop;
close c01;

if (IE_COMMIT_P = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_titulo_receber ( NM_USUARIO_P text, IE_COMMIT_P text, IE_PERMITE_TITULO_EXTERNO_P text) FROM PUBLIC;

