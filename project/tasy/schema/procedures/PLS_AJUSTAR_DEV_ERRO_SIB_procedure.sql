-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_dev_erro_sib ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_lote_sib_w	bigint;
nr_seq_dev_erro_w	bigint;
cd_erro_xml_w		varchar(255);
ds_conteudo_erro_w	varchar(255);
ds_causa_erro_w		varchar(255);
ds_erro_w		varchar(255);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	PLS_LOTE_SIB
	where	cd_estabelecimento	= cd_estabelecimento_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		cd_erro_xml,
		ds_conteudo_erro,
		ds_causa_erro,
		ds_erro
	from	sib_devolucao_erro
	where	nr_seq_lote	= nr_seq_lote_sib_w
	and	ie_xml		= 'S';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_lote_sib_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open c02;
	loop
	fetch c02 into
		nr_seq_dev_erro_w,
		cd_erro_xml_w,
		ds_conteudo_erro_w,
		ds_causa_erro_w,
		ds_erro_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		insert into sib_dev_erro_conteudo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				nr_seq_devolucao_sib,CD_ERRO,ds_erro,vl_campo_erro,ds_mensagem_erro)
		values (	nextval('sib_dev_erro_conteudo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				nr_seq_dev_erro_w,cd_erro_xml_w,ds_conteudo_erro_w,ds_causa_erro_w,ds_erro_w);
		end;
	end loop;
	close c02;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_dev_erro_sib ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
