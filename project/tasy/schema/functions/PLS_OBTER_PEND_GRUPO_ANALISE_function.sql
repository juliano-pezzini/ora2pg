-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_pend_grupo_analise ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_proc_partic_p bigint, nr_seq_grupo_atual_p bigint, ie_informativo_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w      		varchar(1) := null;
qt_glo_ocor_grupo_w 	bigint;
nr_seq_analise_w    	bigint;
qt_fluxo_grupo_w    	bigint  := 0;
qt_fluxo_pend_w     	bigint  := 0;
nr_seq_conta_w      	bigint;
qt_fluxo_grupo_conta_w  bigint;
qt_fluxo_pend_conta_w   bigint;
qt_fluxo_grupo_aux_w    bigint  := 0;
qt_fluxo_pend_aux_w   	bigint  := 0;
nr_seq_ocor_w     		bigint;
nr_seq_conta_ww     	pls_conta.nr_sequencia%type;
tot_glosa_grupo_atual_w	integer;
ie_origem_analise_w	pls_analise_conta.ie_origem_analise%type;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
C01 CURSOR FOR
  SELECT  a.nr_sequencia
  from  pls_conta a
  where a.nr_seq_analise  = nr_seq_analise_p;

C02 CURSOR FOR
  SELECT  a.nr_sequencia
  from  pls_ocorrencia_benef  a
  where a.nr_seq_conta_mat  = nr_seq_conta_mat_p
  and a.nr_seq_conta    = nr_seq_conta_p
  and a.nr_seq_conta_mat in ( SELECT  b.nr_sequencia
          from  pls_conta_mat b
          where b.ie_status <> 'D'
          and b.nr_seq_conta = a.nr_seq_conta);

C03 CURSOR FOR
  SELECT  a.nr_sequencia
  from  pls_ocorrencia_benef  a
  where a.nr_seq_conta_proc = nr_seq_conta_proc_p
  and a.nr_seq_conta    = nr_seq_conta_ww
  and a.nr_seq_conta_proc in (  SELECT  b.nr_sequencia
            from  pls_conta_proc b
            where b.ie_status <> 'D'
            and b.nr_seq_conta = a.nr_seq_conta);

C04 CURSOR FOR
  SELECT  a.nr_sequencia
  from  pls_ocorrencia_benef    a
  where a.nr_seq_conta    = nr_seq_conta_p
  and coalesce(a.nr_seq_conta_proc::text, '') = ''
  and coalesce(a.nr_seq_conta_mat::text, '') = ''
  and coalesce(a.nr_seq_proc_partic::text, '') = '';

C05 CURSOR FOR
  SELECT  	a.nr_sequencia
  from  	pls_ocorrencia_benef    a,
		pls_conta_proc      c
  where 	a.nr_seq_conta_proc = c.nr_sequencia
  and 		c.nr_seq_agrup_analise  = nr_seq_conta_proc_p
  and 		c.ie_status     <> 'D'
  and (c.ie_status	!= 'M' or ie_origem_analise_w != 1);/*Foi retirada a restrição de estar na mesma conta pois o proc referencia pode estar em uma conta diferente drquadros */
TYPE    fetch_array IS TABLE OF C02%ROWTYPE;
s_array   fetch_array;
i   integer := 1;
type Vetor is table of fetch_array index by integer;
Vetor_c02_w     Vetor;

BEGIN
/* Se for para a análise inteira */

select	max(ie_origem_analise)
into STRICT	ie_origem_analise_w
from	pls_analise_conta
where 	nr_sequencia = nr_seq_analise_p;

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') and (coalesce(nr_seq_conta_p::text, '') = '') and (coalesce(nr_seq_conta_proc_p::text, '') = '') and (coalesce(nr_seq_conta_mat_p::text, '') = '') and (coalesce(nr_seq_proc_partic_p::text, '') = '') then
  open C01;
  loop
  fetch C01 into
    nr_seq_conta_w;
  EXIT WHEN NOT FOUND; /* apply on C01 */
    begin
    select  count(1) qt_fluxo
    into STRICT  qt_fluxo_grupo_conta_w
    from  pls_ocorrencia_benef    a,
      pls_analise_glo_ocor_grupo  b
    where a.nr_sequencia    = b.nr_seq_ocor_benef
    and b.nr_seq_analise  = nr_seq_analise_p
    and a.nr_seq_conta    = nr_seq_conta_w
    and b.nr_seq_grupo    = nr_seq_grupo_atual_p
    and b.ie_status  = 'P'
    and   not exists (SELECT   nr_sequencia
           from   pls_conta_proc c
           where  c.ie_status = 'D'
           and    c.nr_seq_conta = a.nr_seq_conta
           and    c.nr_sequencia = a.nr_seq_conta_proc)  LIMIT 1;


    select  count(1) qt_pend
    into STRICT  qt_fluxo_pend_conta_w
    from  pls_ocorrencia_benef    a,
      pls_analise_glo_ocor_grupo  b
    where a.nr_sequencia    = b.nr_seq_ocor_benef
    and b.nr_seq_analise  = nr_seq_analise_p
    and a.nr_seq_conta    = nr_seq_conta_w
    and b.nr_seq_grupo    = nr_seq_grupo_atual_p
    and not exists ( SELECT  nr_sequencia
            from  pls_conta_proc c
            where c.ie_status = 'D'
            and c.nr_seq_conta = a.nr_seq_conta
            and   a.nr_seq_proc = c.nr_sequencia)
    and b.ie_status   = 'P'  LIMIT 1;

    /*and (a.ie_situacao = 'A' or a.ie_situacao = 'P');  Comentado por causa das ocorrências informativas*/

    qt_fluxo_grupo_w  := qt_fluxo_grupo_w + coalesce(qt_fluxo_grupo_conta_w,0);
    qt_fluxo_pend_w   := coalesce(qt_fluxo_pend_w,0) + coalesce(qt_fluxo_pend_conta_w,0);

    end;
  end loop;
  close C01;
else
  if (nr_seq_proc_partic_p IS NOT NULL AND nr_seq_proc_partic_p::text <> '') then
    select  count(1) qt_fluxo
    into STRICT  qt_fluxo_grupo_w
    from  pls_ocorrencia_benef    a,
      pls_analise_glo_ocor_grupo  b
    where a.nr_sequencia    = b.nr_seq_ocor_benef
    and b.nr_seq_analise  = nr_seq_analise_p
    and a.nr_seq_proc_partic  = nr_seq_proc_partic_p
    and b.nr_seq_grupo    = nr_seq_grupo_atual_p  LIMIT 1;

    select  count(1) qt_pend
    into STRICT  qt_fluxo_pend_w
    from  pls_ocorrencia_benef    a,
      pls_analise_glo_ocor_grupo  b
    where a.nr_sequencia    = b.nr_seq_ocor_benef
    and b.nr_seq_analise  = nr_seq_analise_p
    and a.nr_seq_proc_partic  = nr_seq_proc_partic_p
    and b.nr_seq_grupo    = nr_seq_grupo_atual_p
    and b.ie_status   = 'P'  LIMIT 1;
    /*and (a.ie_situacao = 'A' or a.ie_situacao = 'P');  Comentado por causa das ocorrências informativas*/

  elsif (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
    /*tem que fazer select da conta ntes de enviar como parametro, pois o nr_seq_conta_p pode vir com
    a conta principal, e as contas de hi que foram gerada não irão ser buscadas pela regra, drquadros 15/08/2013*/
    select  max(nr_seq_conta)
    into STRICT  nr_seq_conta_ww
    from  pls_conta_proc
    where nr_sequencia = nr_seq_conta_proc_p;

    open C03;
    loop
    fetch C03 into
      nr_seq_ocor_w;
    EXIT WHEN NOT FOUND; /* apply on C03 */
      begin
      select  count(1) qt_fluxo,
        sum(CASE WHEN b.ie_status='P' THEN  1  ELSE 0 END )
      into STRICT  qt_fluxo_grupo_aux_w,
        qt_fluxo_pend_aux_w
      from  pls_analise_glo_ocor_grupo  b
      where b.nr_seq_analise  = nr_seq_analise_p
      and b.nr_seq_ocor_benef = nr_seq_ocor_w
      and b.nr_seq_grupo    = nr_seq_grupo_atual_p;

      qt_fluxo_grupo_w  := coalesce(qt_fluxo_grupo_w,0) + coalesce(qt_fluxo_grupo_aux_w,0);
      qt_fluxo_pend_w   := coalesce(qt_fluxo_pend_w,0) + coalesce(qt_fluxo_pend_aux_w,0);
      end;
    end loop;
    close C03;

    if (ie_informativo_p = 'S') and (qt_fluxo_pend_w = 0) then
      open C05;
      loop
      fetch C05 into
        nr_seq_ocor_w;
      EXIT WHEN NOT FOUND; /* apply on C05 */
        begin
        select  count(1) qt_fluxo,
          sum(CASE WHEN b.ie_status='P' THEN  1  ELSE 0 END )
        into STRICT  qt_fluxo_grupo_aux_w,
          qt_fluxo_pend_aux_w
        from  pls_analise_glo_ocor_grupo  b
        where b.nr_seq_analise  = nr_seq_analise_p
        and b.nr_seq_ocor_benef = nr_seq_ocor_w
        and b.nr_seq_grupo    = nr_seq_grupo_atual_p;

        qt_fluxo_grupo_w  := coalesce(qt_fluxo_grupo_w,0) + coalesce(qt_fluxo_grupo_aux_w,0);
        qt_fluxo_pend_w   := coalesce(qt_fluxo_pend_w,0) + coalesce(qt_fluxo_pend_aux_w,0);
        end;
      end loop;
      close C05;
    end if;
  elsif (nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
    open C02;
    loop
    FETCH C02 BULK COLLECT INTO s_array LIMIT 1000;
      Vetor_c02_w(i) := s_array;
      i := i + 1;
    EXIT WHEN NOT FOUND; /* apply on C02 */
    END LOOP;
    CLOSE C02;

    for i in 1..Vetor_c02_w.COUNT loop
      s_array := Vetor_c02_w(i);
      for z in 1..s_array.COUNT loop
        begin
        nr_seq_ocor_w := s_array[z].nr_sequencia;

        select  count(1) qt_fluxo,
          sum(CASE WHEN b.ie_status='P' THEN  1  ELSE 0 END )
        into STRICT  qt_fluxo_grupo_aux_w,
          qt_fluxo_pend_aux_w
        from  pls_analise_glo_ocor_grupo  b
        where b.nr_seq_analise  = nr_seq_analise_p
        and b.nr_seq_ocor_benef = nr_seq_ocor_w
        and b.nr_seq_grupo    = nr_seq_grupo_atual_p;

        qt_fluxo_grupo_w  := coalesce(qt_fluxo_grupo_w,0) + coalesce(qt_fluxo_grupo_aux_w,0);
        qt_fluxo_pend_w   := coalesce(qt_fluxo_pend_w,0) + coalesce(qt_fluxo_pend_aux_w,0);
        end;
      end loop;
    end loop;

    /*open C02;
    loop
    fetch C02 into
      nr_seq_ocor_w;
    exit when C02%notfound;
      begin
      select  count(1) qt_fluxo,
        sum(decode(b.ie_status, 'P', 1, 0))
      into  qt_fluxo_grupo_aux_w,
        qt_fluxo_pend_aux_w
      from  pls_analise_glo_ocor_grupo  b
      where b.nr_seq_analise  = nr_seq_analise_p
      and b.nr_seq_ocor_benef = nr_seq_ocor_w
      and b.nr_seq_grupo    = nr_seq_grupo_atual_p;

      qt_fluxo_grupo_w  := qt_fluxo_grupo_w + qt_fluxo_grupo_aux_w;
      qt_fluxo_pend_w   := qt_fluxo_pend_w + qt_fluxo_pend_aux_w;
      end;
    end loop;
    close C02;*/
  elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
    open C04;
    loop
    fetch C04 into
      nr_seq_ocor_w;
    EXIT WHEN NOT FOUND; /* apply on C04 */
      begin

      /*No caso da conta, considera como pendente as ocorrências independente do grupo vinculado. Apenas se estiver ativa,
      que significa que não teve parecer ainda . Isso serve para impedir que sejam habilitados os controles dos itens da conta
      antes do parecer da conta. Ao marcar os itens pendentes da análise, ocorria um problema nessa verificação, pois a conta
      não era exibida como pendente, pois a ocorrência da conta só estava vinculada ao grupo seguinte e com isso os controles dos
	  itens ficavam habilitados. Foi removido a estrição de status da ocorrência pois não estavam sendo exibidas as ocorrências inativas que tinham o fluxo pendente para o grupo*/
      select count(1) qt_fluxo,
			 sum(CASE WHEN b.ie_status='P' THEN  1  ELSE 0 END )
      into STRICT   qt_fluxo_grupo_aux_w,
			 qt_fluxo_pend_aux_w
      from   pls_analise_glo_ocor_grupo  b,
			 pls_ocorrencia_benef    c
      where  b.nr_seq_analise  	 = nr_seq_analise_p
      and 	 b.nr_seq_ocor_benef = c.nr_sequencia
      and 	 b.nr_seq_ocor_benef = nr_seq_ocor_w;

	  /*Aqui verifica se existe ocorrência pendente específicamente para o grupo atual, pois caso foi dado parecer na conta no grupo atual,
	  não exibirá a mesma como pendente. A verificação é contrária à verificação anterior pois naquela, é preciso tratar casos onde existe
	  ocorrência pendente na conta para o grupo de análise seguinte e não no atual, pois se não ha parecer na ocorrência da conta, não deve
	  liberar as ações sofre os itens
	  */
	  select count(1)
	  into STRICT	tot_glosa_grupo_atual_w
	  from	pls_analise_glo_ocor_grupo  b,
			pls_ocorrencia_benef    c
	  where b.nr_seq_analise  	= nr_seq_analise_p
      and 	b.nr_seq_ocor_benef = c.nr_sequencia
      and 	b.nr_seq_ocor_benef = nr_seq_ocor_w
	  and   b.nr_seq_grupo    	= nr_seq_grupo_atual_p
	  and	b.ie_status <> 'P';

	  -- Se form maior que zero, então quer dizer que tinha fluxo para o grupo e o mesmo já deu parecer
	  if ( tot_glosa_grupo_atual_w > 0) then
			qt_fluxo_pend_aux_w := 0;
	  end if;

      qt_fluxo_grupo_w  := coalesce(qt_fluxo_grupo_w,0) + coalesce(qt_fluxo_grupo_aux_w,0);
      qt_fluxo_pend_w   := coalesce(qt_fluxo_pend_w,0) + coalesce(qt_fluxo_pend_aux_w,0);

      end;
    end loop;
    close C04;
  end if;
end if;

/* Se o item tem fluxo pendente pro grupo  */

if (qt_fluxo_pend_w > 0) then
  ie_retorno_w  := 'S';
/* Verificar se tem fluxo para o grupo, para trazer o ícone de analisado */

elsif (qt_fluxo_grupo_w > 0) then
  ie_retorno_w  := 'N';
end if;

return  ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_pend_grupo_analise ( nr_seq_analise_p bigint, nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_proc_partic_p bigint, nr_seq_grupo_atual_p bigint, ie_informativo_p text) FROM PUBLIC;
