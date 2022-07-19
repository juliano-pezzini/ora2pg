-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_altera_sit_ocor ( nr_seq_analise_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Mudar a situação das glosas e ocorrências conforme alterado na tabela temporária
(Análise Nova)
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_situacao_w		varchar(1);
nr_seq_conta_glosa_w	bigint;
nr_seq_ocor_benef_w	bigint;
nr_seq_glosa_w		bigint;
ie_forma_inativacao_w	pls_conta_glosa.ie_forma_inativacao%type;
nr_seq_mot_glosa_w	tiss_motivo_glosa.nr_sequencia%type;
qt_glosa_temp_w		integer;

C01 CURSOR FOR
	SELECT	a.nr_seq_conta_glosa,
		a.nr_seq_ocor_benef,
		min(a.ie_situacao)
	from	w_pls_analise_glosa_ocor a
	where	a.nr_seq_analise	= nr_seq_analise_p
	and	a.nm_usuario		= nm_usuario_p
	and (a.ie_inserido_auditor = 'N' or coalesce(a.ie_inserido_auditor::text, '') = '')
	group by a.nr_seq_conta_glosa,a.nr_seq_ocor_benef;


BEGIN

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		nr_seq_conta_glosa_w,
		nr_seq_ocor_benef_w,
		ie_situacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (nr_seq_conta_glosa_w IS NOT NULL AND nr_seq_conta_glosa_w::text <> '') then
			if (ie_situacao_w	= 'I') then
				ie_forma_inativacao_w	:= 'U';
			else
				ie_forma_inativacao_w	:= null;
			end if;
			update	pls_conta_glosa
			set	ie_situacao 		= ie_situacao_w,
				ie_forma_inativacao	= CASE WHEN ie_forma_inativacao = NULL THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_forma_inativacao='U' THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_situacao_w='I' THEN 'US'  ELSE null END  END  END ,
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_conta_glosa_w;
		elsif (nr_seq_ocor_benef_w IS NOT NULL AND nr_seq_ocor_benef_w::text <> '') then

			select	max(a.nr_seq_motivo_glosa)
			into STRICT	nr_seq_mot_glosa_w
			from	pls_ocorrencia a,
				pls_ocorrencia_benef b
			where	a.nr_sequencia = b.nr_seq_ocorrencia
			and	b.nr_sequencia = nr_seq_ocor_benef_w;

			select	count(1)
			into STRICT	qt_glosa_temp_w
			from	w_pls_analise_glosa_ocor a
			where	a.nr_seq_analise	= nr_seq_analise_p
			and	a.nm_usuario		= nm_usuario_p
			and	a.nr_seq_motivo_glosa 	= nr_seq_mot_glosa_w
			and	a.ie_situacao 		= 'A';

			if (qt_glosa_temp_w = 0) or (ie_situacao_w = 'A') then
				if (ie_situacao_w	= 'I') then
						ie_forma_inativacao_w	:= 'U';
					else
						ie_forma_inativacao_w	:= null;
				end if;

				update	pls_ocorrencia_benef
				set	ie_situacao		= ie_situacao_w,
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao = NULL THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_forma_inativacao='U' THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_situacao_w='I' THEN 'US'  ELSE null END  END  END ,
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= nr_seq_ocor_benef_w;

				update	pls_ocorrencia_benef
				set	ie_situacao		= ie_situacao_w,
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao = NULL THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_forma_inativacao='U' THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_situacao_w='I' THEN 'US'  ELSE null END  END  END ,
					nm_usuario		= nm_usuario_p
				where	nr_seq_ocor_pag		= nr_seq_ocor_benef_w;

				update	pls_conta_glosa
				set	ie_situacao		= ie_situacao_w,
					ie_forma_inativacao	= CASE WHEN ie_forma_inativacao = NULL THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_forma_inativacao='U' THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_situacao_w='I' THEN 'US'  ELSE null END  END  END ,
					nm_usuario		= nm_usuario_p
				where	nr_seq_ocorrencia_benef = nr_seq_ocor_benef_w;

				begin
					select	a.nr_seq_glosa
					into STRICT	nr_seq_glosa_w
					from	pls_ocorrencia_benef a
					where	a.nr_sequencia	= nr_seq_ocor_benef_w;
				exception
				when others then
					nr_seq_glosa_w := null;
				end;
				if (coalesce(nr_seq_glosa_w::text, '') = '') then
					begin
						select	a.nr_sequencia
						into STRICT	nr_seq_glosa_w
						from	pls_conta_glosa a
						where	a.nr_seq_ocorrencia_benef	= nr_seq_ocor_benef_w;
					exception
					when others then
						nr_seq_glosa_w	:= null;
					end;
				end if;

				if (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '') then
					update	pls_conta_glosa
					set	ie_situacao		= ie_situacao_w,
						ie_forma_inativacao	= CASE WHEN ie_forma_inativacao = NULL THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_forma_inativacao='U' THEN ie_forma_inativacao_w  ELSE CASE WHEN ie_situacao_w='I' THEN 'US'  ELSE null END  END  END ,
						nm_usuario		= nm_usuario_p
					where	nr_sequencia		= nr_seq_glosa_w;
				end if;
			end if;
		end if;
		end;
	end loop;
	close C01;
end if;

/* Intermediaria - sem commit */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_altera_sit_ocor ( nr_seq_analise_p bigint, nm_usuario_p text) FROM PUBLIC;

