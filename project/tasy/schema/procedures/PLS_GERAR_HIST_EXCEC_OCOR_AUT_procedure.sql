-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_hist_excec_ocor_aut ( nr_seq_requisicao_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar um histórico na requisição com todas as regras de exceções que a requisição se encaixou, estes registros se encontram na tabela PLS_CONTROLE_OCOR_AUT.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_historico_w				varchar(4000);
cd_ocorrencia_w				varchar(255);
nr_seq_ocorrencia_w			bigint;
nr_seq_excecao_w			bigint;

C01 CURSOR FOR
	SELECT	nr_seq_ocorrencia,
		nr_seq_excecao
	from	pls_controle_ocor_aut
	where	nr_seq_requisicao	= nr_seq_requisicao_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_ocorrencia_w,
	nr_seq_excecao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	begin
		select	cd_ocorrencia
		into STRICT	cd_ocorrencia_w
		from	pls_ocorrencia
		where	nr_sequencia	= nr_seq_ocorrencia_w;
	exception
	when others then
		cd_ocorrencia_w	:= null;
	end;

	ds_historico_w	:= substr(substr(ds_historico_w,1,4000)||chr(10)||'Ocorrência --> '||cd_ocorrencia_w||'	Exceção --> '||nr_seq_excecao_w,1,4000);
	end;
end loop;
close C01;

CALL pls_requisicao_gravar_hist(	nr_seq_requisicao_p,'L',substr('Exceções em que a requisição se encaixou:'||ds_historico_w,1,4000),
				'',nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_hist_excec_ocor_aut ( nr_seq_requisicao_p bigint, nm_usuario_p text) FROM PUBLIC;
