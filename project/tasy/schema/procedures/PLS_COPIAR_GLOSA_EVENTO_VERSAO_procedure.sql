-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_glosa_evento_versao (nm_owner_origem_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Criar procedure específica para tratar cópia da tabela PLS_GLOSA_EVENTO, pois
a tabela superior (TISS_MOTIVO_GLOSA) não vai na versão.
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

ATENCAO!!!!!!!!!!!!!!!!

SEMPRE QUE FOR ALTERADA ESSA ROTINA, A MESMA DEVE SER DOCUMENTADA NO DF1, ajustes versão
Pois senão será recriada apenas na Fase 2, não copiando certo a tabela

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_motivo_tiss_w	tiss_motivo_glosa.cd_motivo_tiss%type;
vl_retorno_w            varchar(255);
ds_comando_w            varchar(2000);
nr_seq_motivo_glosa_w	tiss_motivo_glosa.nr_sequencia%type;
nr_seq_glosa_evento_w	pls_glosa_evento.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	a.cd_motivo_tiss
	from	pls_glosa_evento a
	where	(a.cd_motivo_tiss IS NOT NULL AND a.cd_motivo_tiss::text <> '')
	and	not exists (SELECT	1
				from	tiss_motivo_glosa x
				where	x.nr_sequencia = a.nr_seq_motivo_glosa);

c02 CURSOR FOR
	SELECT	a.nr_sequencia,
		b.cd_motivo_tiss
	from	tiss_motivo_glosa b,
		pls_glosa_evento a
	where	a.nr_seq_motivo_glosa = b.nr_sequencia
	and	coalesce(a.cd_motivo_tiss::text, '') = '';


BEGIN
/* Atualizar o campo novo CD_MOTIVO_TISS nos registros já existentes  e que ainda está vazio */

open C02;
loop
fetch C02 into
	nr_seq_glosa_evento_w,
	cd_motivo_tiss_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	update	pls_glosa_evento
	set	cd_motivo_tiss	= cd_motivo_tiss_w
	where	nr_sequencia	= nr_seq_glosa_evento_w;
	end;
end loop;
close C02;

/* Desabilitar integridade com motivo de glosa */

ds_comando_w := 'alter table pls_glosa_evento disable constraint PLSGLEV_TISSMGL_FK';
vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);

Tasy_Copiar_tabela(nm_owner_origem_p,'pls_glosa_evento','N','N','where (a.ie_vai_versao = ' || chr(39) || 'S' || chr(39) || ' or a.ie_vai_versao is null) ' || /* Só o que está pronto para ir na versão */
								' and	a.cd_motivo_tiss >= ' || chr(39) || '1001' || chr(39) || ' ' || /* Só glosas válidas */
								' and	not exists (select 1 from pls_glosa_evento b where b.nr_sequencia = a.nr_sequencia) ' || /* Não violar pk */
								' and	not exists (	select	1 ' ||
								'			from	pls_glosa_evento b ' ||
								'			where	b.ie_evento = a.ie_evento ' ||
								'			and	b.cd_motivo_tiss = a.cd_motivo_tiss)');

/* Esse cursor é necessário para gravar o Seq do Motivo de glosa conforme base do cliente */

open C01;
loop
fetch C01 into
	cd_motivo_tiss_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select		min(x.nr_sequencia)
	into STRICT		nr_seq_motivo_glosa_w
	from		tiss_motivo_glosa x
	where		x.cd_motivo_tiss	= cd_motivo_tiss_w;

	if (nr_seq_motivo_glosa_w IS NOT NULL AND nr_seq_motivo_glosa_w::text <> '') then
		update	pls_glosa_evento a
		set	nr_seq_motivo_glosa	= nr_seq_motivo_glosa_w
		where	cd_motivo_tiss		= cd_motivo_tiss_w;
	end if;
	end;
end loop;
close C01;

/* Reabilitar integridade com motivo de glosa */

ds_comando_w := 'alter table pls_glosa_evento enable constraint PLSGLEV_TISSMGL_FK';
vl_retorno_w := Obter_Valor_Dinamico(ds_comando_w, vl_retorno_w);
/* Sem commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_glosa_evento_versao (nm_owner_origem_p text) FROM PUBLIC;

