-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_gerar_itens_analise_agua_js (nr_seq_protocolo_analise_p bigint, nr_seq_ponto_acesso_p bigint, cd_estabelecimento_p bigint, ie_tipo_controle_p text, ie_acao_executada_p bigint, nr_seq_analise_agua_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_prot_exame_micro_w 	bigint;
nr_seq_prot_exame_fisico_w	bigint;
nr_seq_prot_exame_w		bigint;
nr_seq_protocolo_w		bigint;


BEGIN

select	max(nr_seq_prot_exame_micro) nr_seq_prot_exame_micro,
	max(nr_seq_prot_exame_fisico) nr_seq_prot_exame_fisico
into STRICT	nr_seq_prot_exame_micro_w,
	nr_seq_prot_exame_fisico_w
from 	hd_parametro
where 	cd_estabelecimento = cd_estabelecimento_p;

select	max(nr_seq_prot_exame) nr_seq_prot_exame
into STRICT	nr_seq_prot_exame_w
from    hd_ponto_acesso
where   nr_sequencia = nr_seq_ponto_acesso_p;


if (nr_seq_protocolo_analise_p > 0) and (ie_acao_executada_p = 1) then

	nr_seq_protocolo_w :=  nr_seq_protocolo_analise_p;

elsif (nr_seq_prot_exame_micro_w > 0) and (ie_tipo_controle_p = 'M') and (ie_acao_executada_p = 1) then

	nr_seq_protocolo_w :=  nr_seq_prot_exame_micro_w;

elsif (nr_seq_prot_exame_fisico_w > 0) and (ie_tipo_controle_p = 'F') and (ie_acao_executada_p = 1) then

	nr_seq_protocolo_w :=  nr_seq_prot_exame_fisico_w;

else 	nr_seq_protocolo_w :=  nr_seq_prot_exame_w;

end if;


CALL Hd_gerar_itens_analise_agua(nr_seq_protocolo_w,nr_seq_analise_agua_p,nm_usuario_p);


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_gerar_itens_analise_agua_js (nr_seq_protocolo_analise_p bigint, nr_seq_ponto_acesso_p bigint, cd_estabelecimento_p bigint, ie_tipo_controle_p text, ie_acao_executada_p bigint, nr_seq_analise_agua_p bigint, nm_usuario_p text) FROM PUBLIC;

