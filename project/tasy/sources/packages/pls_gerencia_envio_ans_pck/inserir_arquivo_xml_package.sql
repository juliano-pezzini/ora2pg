-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Controlar a quantidade de arquivos XML que sero gerados para envio



CREATE OR REPLACE PROCEDURE pls_gerencia_envio_ans_pck.inserir_arquivo_xml ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE



tb_up_arq_seq_w		pls_util_cta_pck.t_number_table;
tb_up_guia_seq_w	pls_util_cta_pck.t_number_table;

nr_seq_arquivo_xml_w	pls_monitor_tiss_arquivo.nr_sequencia%type;
nm_arquivo_w		pls_monitor_tiss_arquivo.nm_arquivo%type;
qt_registro_upd_w	integer;


qt_contas_arquivo_w 		integer 	:= 0; --Quantidade de contas no arquivo
qt_total_contas_arquivo_w 	integer	:= 0; --Total de conta por arquivo
nr_arquivo_atual_w		integer	:= 0; --Nmero do arquivo que esta sendo criado
qt_registros_w			integer;


C01 CURSOR( nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type	) FOR
	SELECT 	a.nr_sequencia
	from 	pls_monitor_tiss_guia a
	where 	a.nr_seq_lote_monitor = nr_seq_lote_pc;

BEGIN

select	count(1)
into STRICT	qt_registros_w
from	pls_monitor_tiss_guia
where 	nr_seq_lote_monitor	= nr_seq_lote_p  LIMIT 1;

--aaschlote OS 863382 - Tratamento para a gerao do arquivo sem contas

if (qt_registros_w = 0) then
	select	nextval('pls_monitor_tiss_arquivo_seq')
	into STRICT	nr_seq_arquivo_xml_w
	;

	nr_arquivo_atual_w := nr_arquivo_atual_w + 1;

	--Gerar o nome do arquivo que dever ser enviado para ANS

	nm_arquivo_w := pls_gerencia_envio_ans_pck.obter_nome_arquivo(nr_seq_lote_p, nr_seq_arquivo_xml_w);

	insert into pls_monitor_tiss_arquivo(
		nr_sequencia, nr_seq_lote_monitor, dt_geracao_arquivo,
		nm_arquivo, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_arquivo)
	values (	nr_seq_arquivo_xml_w, nr_seq_lote_p, clock_timestamp(),
		nm_arquivo_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, nr_arquivo_atual_w);
else
	--Se no existir valor para o parmetro de quantidade de arquivo o padro ser de 10.000 contas, conforme definido na norma da ANS

	select	coalesce(max( qt_conta_arquivo ), 10000)
	into STRICT	qt_total_contas_arquivo_w
	from 	pls_monitor_tiss_param;

	qt_registro_upd_w := 0;

	for c01_w in C01( nr_seq_lote_p ) loop

		--Tratamento utilizado para gerao e controle de quantidade de contas no arquivo XML

		if ( qt_contas_arquivo_w = 0 or qt_contas_arquivo_w = qt_total_contas_arquivo_w ) then

			nr_arquivo_atual_w := nr_arquivo_atual_w + 1;

			select	nextval('pls_monitor_tiss_arquivo_seq')
			into STRICT	nr_seq_arquivo_xml_w
			;

			--Gerar o nome do arquivo que dever ser enviado para ANS

			nm_arquivo_w := pls_gerencia_envio_ans_pck.obter_nome_arquivo(nr_seq_lote_p, nr_seq_arquivo_xml_w);

			insert into pls_monitor_tiss_arquivo(
				nr_sequencia, nr_seq_lote_monitor, dt_geracao_arquivo,
				nm_arquivo, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, nr_arquivo)
			values (	nr_seq_arquivo_xml_w, nr_seq_lote_p, clock_timestamp(),
				nm_arquivo_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, nr_arquivo_atual_w);

		end if;

		qt_contas_arquivo_w := qt_contas_arquivo_w + 1;

		if ( qt_contas_arquivo_w > 0 and qt_contas_arquivo_w = qt_total_contas_arquivo_w ) then
			qt_contas_arquivo_w := 0;
		end if;

		tb_up_guia_seq_w(qt_registro_upd_w) 	:= c01_w.nr_sequencia;
		tb_up_arq_seq_w(qt_registro_upd_w) 	:= nr_seq_arquivo_xml_w;

		qt_registro_upd_w := qt_registro_upd_w + 1;

		if ( qt_registro_upd_w >= current_setting('pls_gerencia_envio_ans_pck.qt_registro_transacao_w')::integer ) then

			-- se tiver algo para atualizar

			if (tb_up_guia_seq_w.count > 0) then

				forall i in tb_up_guia_seq_w.first..tb_up_guia_seq_w.last
					update	pls_monitor_tiss_guia
					set	nm_usuario			= nm_usuario_p,
						dt_atualizacao			= clock_timestamp(),
						nr_seq_arq_monitor		= tb_up_arq_seq_w(i)
					where	nr_sequencia 			= tb_up_guia_seq_w(i);

				commit;

				tb_up_guia_seq_w.delete;
				tb_up_arq_seq_w.delete;
				qt_registro_upd_w := 0;
			end if;
		end if;
	end loop;

	-- se tiver algo para atualizar

	if ( tb_up_guia_seq_w.count > 0) then
		-- se tiver algo para atualizar

		if (tb_up_guia_seq_w.count > 0) then

			forall i in tb_up_guia_seq_w.first..tb_up_guia_seq_w.last
				update	pls_monitor_tiss_guia
				set	nm_usuario			= nm_usuario_p,
					dt_atualizacao			= clock_timestamp(),
					nr_seq_arq_monitor		= tb_up_arq_seq_w(i)
				where	nr_sequencia 			= tb_up_guia_seq_w(i);

			commit;

			tb_up_guia_seq_w.delete;
			tb_up_arq_seq_w.delete;
		end if;
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerencia_envio_ans_pck.inserir_arquivo_xml ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
