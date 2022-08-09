-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_lim_ocorr_exec ( nr_seq_segurado_p bigint, nr_seq_execucao_p bigint, ie_tipo_intercambio_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção:Performance. 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_regra_liminar_w		bigint;
nr_seq_auditoria_w		bigint;
ie_utiliza_nivel_w		varchar(1) := 'N';


BEGIN 
if (coalesce(ie_tipo_intercambio_P,'X')	<> 'I') then 
	if (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then 
		nr_seq_regra_liminar_w := pls_gerar_ocorr_liminar_exec(	nr_seq_segurado_p, null, nr_seq_execucao_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_liminar_w);
 
		begin 
			select	nr_sequencia 
			into STRICT	nr_seq_auditoria_w 
			from	pls_auditoria 
			where	nr_seq_execucao	= nr_seq_execucao_p;
		exception 
		when others then 
			nr_seq_auditoria_w	:= null;
		end;
 
		if (nr_seq_regra_liminar_w IS NOT NULL AND nr_seq_regra_liminar_w::text <> '') and (nr_seq_auditoria_w IS NOT NULL AND nr_seq_auditoria_w::text <> '') then 
 
			ie_utiliza_nivel_w := pls_obter_se_uti_nivel_lib_aut(cd_estabelecimento_p);
 
			if (ie_utiliza_nivel_w = 'S') then 
				CALL pls_gerar_ocor_glosa_exec_lim(nr_seq_auditoria_w, nr_seq_execucao_p, nr_seq_regra_liminar_w, nm_usuario_p);
			end if;
		end if;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consist_lim_ocorr_exec ( nr_seq_segurado_p bigint, nr_seq_execucao_p bigint, ie_tipo_intercambio_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
